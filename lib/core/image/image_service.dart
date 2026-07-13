import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  static Future<FilePickerResult?> getImages() async {
    var hasPermission = await _requestWritePermission();
    if (!hasPermission) return null;

    var result = await FilePicker.pickFiles(
        allowMultiple: true, withData: true, type: FileType.image);

    return result;
  }

  static Future<FilePickerResult?> getImage() async {
    var hasPermission = await _requestWritePermission();
    if (!hasPermission) return null;

    var result =
        await FilePicker.pickFiles(withData: true, type: FileType.image);

    return result;
  }

  static Future<FilePickerResult?> getFile() => FilePicker.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

  static Future<bool> _requestWritePermission() async {
    await Permission.photos.request();
    return await Permission.photos.request().isGranted;
  }
}
