import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' hide GlobalMaterialLocalizations;

extension BuildAndPump on WidgetTester {
  Future<void> buildAndPump(Widget child) async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppFlowyEditorLocalizations.delegate,
        ],
        supportedLocales: AppFlowyEditorLocalizations.delegate.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: child,
        ),
      ),
    );
    await pump();
  }
}
