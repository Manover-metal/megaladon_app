import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:megaladon/core/image/platform_file.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  // uniformTypeIdentifiers нужны iOS, extensions и mimeTypes — Android.
  static const _pdfGroup = XTypeGroup(
    label: 'PDF',
    extensions: ['pdf'],
    mimeTypes: ['application/pdf'],
    uniformTypeIdentifiers: ['com.adobe.pdf'],
  );
  static const _documentGroup = XTypeGroup(
    label: 'Documents',
    extensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    mimeTypes: [
      'image/jpeg',
      'image/png',
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    ],
    uniformTypeIdentifiers: [
      'public.jpeg',
      'public.png',
      'com.adobe.pdf',
      'com.microsoft.word.doc',
      'org.openxmlformats.wordprocessingml.document',
    ],
  );

  /// Документ из файловой системы. Возвращает [File] или null при отмене.
  static Future<File?> getDocument() async {
    final file = await openFile(acceptedTypeGroups: const [_documentGroup]);
    return file == null ? null : File(file.path);
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

  /// Несколько фото из галереи; пустой список при отмене.
  static Future<List<PlatformFile>> getImages() async =>
      Future.wait((await _picker.pickMultiImage()).map(_toPlatformFile));

  /// Фото из галереи с содержимым; null при отмене.
  static Future<PlatformFile?> getImage() async {
    final photo = await _picker.pickImage(source: ImageSource.gallery);
    return photo == null ? null : _toPlatformFile(photo);
  }

  /// Несколько документов; пустой список при отмене.
  static Future<List<PlatformFile>> getDocuments() async => Future.wait(
      (await openFiles(acceptedTypeGroups: const [_documentGroup]))
          .map(_toPlatformFile));

  /// PDF с содержимым; null при отмене.
  static Future<PlatformFile?> getPdf() async {
    final file = await openFile(acceptedTypeGroups: const [_pdfGroup]);
    return file == null ? null : _toPlatformFile(file);
  }

  static Future<PlatformFile> _toPlatformFile(XFile file) async {
    final bytes = await file.readAsBytes();
    return PlatformFile(
      name: file.name,
      size: bytes.length,
      bytes: bytes,
      path: file.path,
    );
  }
}
