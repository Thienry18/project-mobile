import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<File?> pickSingleFile({List<String>? allowedExtensions}) async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (res == null || res.files.isEmpty) return null;
    return File(res.files.single.path!);
  }

  static Future<Directory> appDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }
}
