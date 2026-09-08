import 'package:appflowy_editor/src/editor/util/file_picker/file_picker_service.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/foundation.dart';

class FilePicker implements FilePickerService {
  @override
  Future<String?> getDirectoryPath({String? title}) {
    return fp.FilePicker.getDirectoryPath();
  }

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    fp.FileType type = fp.FileType.any,
    List<String>? allowedExtensions,
    Function(fp.FilePickerStatus p1)? onFileLoading,
    bool lockParentWindow = false,
  }) async {
    final result = await fp.FilePicker.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      windowsOptions: fp.WindowsOptions(lockParentWindow: lockParentWindow),
      linuxOptions: fp.LinuxOptions(lockParentWindow: lockParentWindow),
    );
    return FilePickerResult(result);
  }

  @override
  Future<Uri?> saveFile({
    required String fileName,
    required Uint8List bites,
    String? dialogTitle,
    String? initialDirectory,
    fp.FileType type = fp.FileType.any,
    List<String>? allowedExtensions,
    bool lockParentWindow = false,
  }) {
    return fp.FilePicker.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      bytes: bites,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      windowsOptions: fp.WindowsOptions(lockParentWindow: lockParentWindow),
      linuxOptions: fp.LinuxOptions(lockParentWindow: lockParentWindow),
    );
  }
}
