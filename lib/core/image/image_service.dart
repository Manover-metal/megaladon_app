import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Документ из файловой системы. Возвращает [File] или null при отмене.
  static Future<File?> getDocument() async {
    final result = await getFile();
    if (result == null || result.files.isEmpty) return null;
    final path = result.files.first.path;
    return path == null ? null : File(path);
  }

  /// Фото из галереи. Возвращает [File] или null при отмене.
  static Future<File?> getGalleryPhoto() async {
    final photo = await _picker.pickImage(source: ImageSource.gallery);
    return photo == null ? null : File(photo.path);
  }

  /// Фото с камеры. Возвращает [File] или null при отмене.
  static Future<File?> getCameraPhoto() async {
    final photo = await _picker.pickImage(source: ImageSource.camera);
    return photo == null ? null : File(photo.path);
  }

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
