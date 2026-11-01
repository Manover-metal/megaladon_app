import 'dart:typed_data';

/// Выбранный пользователем файл: имя для загрузки, содержимое и путь на диске.
class PlatformFile {
  const PlatformFile({
    required this.name,
    required this.size,
    this.bytes,
    this.path,
  });

  final String name;
  final int size;
  final Uint8List? bytes;
  final String? path;
}
