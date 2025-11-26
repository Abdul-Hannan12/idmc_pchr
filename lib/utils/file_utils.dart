import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

Future<File?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    allowCompression: true,
    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    compressionQuality: 50,
    type: FileType.custom,
  );
  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else {
    return null;
  }
}

Future<File?> pickImage({ImageSource? source}) async {
  try {
    final XFile? xfile = await ImagePicker().pickImage(
      source: source ?? ImageSource.camera,
      imageQuality: 50,
    );
    if (xfile != null) {
      return File(xfile.path);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<List<File>?> pickImages() async {
  try {
    final List<XFile> xfiles = await ImagePicker().pickMultiImage(
      imageQuality: 50,
    );
    return xfiles.filesList;
  } catch (e) {
    return null;
  }
}

extension XFilesListExtension on List<XFile> {
  List<File> get filesList => map((x) => File(x.path)).toList();
}
