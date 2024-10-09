import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';

/// A [Delta] encoder that encodes a [Delta] to Markdown.
///
/// Only support inline styles, like bold, italic, underline, strike, code.
class DeltaMarkdownEncoder extends Converter<Delta, String> {
  static const int $space = 0x20;
  static const int $noWrapSpace = 0x00A0;

  @override
  String convert(Delta input) {
    final buffer = StringBuffer();
    final iterator = input.iterator;
    while (iterator.moveNext()) {
      final op = iterator.current;
      if (op is TextInsert) {
        final attributes = op.attributes;
        String text = op.text;

        if (buffer.isEmpty) {
          text = _encodeLeadingSpaces(text);
        }
        
        if (text.contains('\n')) {
          text = text.split('\n').map((e) => e.trimRight()).join('  \n');
        }

        if (attributes != null) {
          buffer.write(_prefixSyntax(attributes));
          buffer.write(text);
          buffer.write(_suffixSyntax(attributes));
        } else {
          buffer.write(text);
        }
      }
    }
    return buffer.toString();
  }

  String _prefixSyntax(Attributes attributes) {
    var syntax = '';

    if (attributes[BuiltInAttributeKey.bold] == true &&
        attributes[BuiltInAttributeKey.italic] == true) {
      syntax += '***';
    } else if (attributes[BuiltInAttributeKey.bold] == true) {
      syntax += '**';
    } else if (attributes[BuiltInAttributeKey.italic] == true) {
      syntax += '_';
    }

    if (attributes[BuiltInAttributeKey.strikethrough] == true) {
      syntax += '~~';
    }
    if (attributes[BuiltInAttributeKey.underline] == true) {
      syntax += '<u>';
    }
    if (attributes[BuiltInAttributeKey.code] == true) {
      syntax += '`';
    }

    if (attributes[BuiltInAttributeKey.href] != null) {
      syntax += '[';
    }

    return syntax;
  }

  String _suffixSyntax(Attributes attributes) {
    var syntax = '';

    if (attributes[BuiltInAttributeKey.href] != null) {
      syntax += '](${attributes[BuiltInAttributeKey.href]})';
    }

    if (attributes[BuiltInAttributeKey.code] == true) {
      syntax += '`';
    }

    if (attributes[BuiltInAttributeKey.underline] == true) {
      syntax += '</u>';
    }

    if (attributes[BuiltInAttributeKey.strikethrough] == true) {
      syntax += '~~';
    }

    if (attributes[BuiltInAttributeKey.bold] == true &&
        attributes[BuiltInAttributeKey.italic] == true) {
      syntax += '***';
    } else if (attributes[BuiltInAttributeKey.bold] == true) {
      syntax += '**';
    } else if (attributes[BuiltInAttributeKey.italic] == true) {
      syntax += '_';
    }

    return syntax;
  }

  String _encodeLeadingSpaces(String text) {
    if (text.isEmpty || ![$space, $noWrapSpace].contains(text.codeUnits.first)) {
      return text;
    }

    final clearedString = text.trimLeft();
    final spaceCount = text.length - clearedString.length;

    if (spaceCount == 0) {
      return text;
    }

    String prefix = '';

    for (int i = 0; i < spaceCount; i++) {
      prefix += String.fromCharCode(i.isEven ? $noWrapSpace : $space);
    }

    return '$prefix$clearedString';
  }
}
