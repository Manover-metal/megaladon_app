import 'dart:io';

import 'package:megaladon/core/dio/index.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  /// Качает файл во внутреннюю папку приложения. Разрешения не нужны:
  /// getApplicationDocumentsDirectory() — приватное хранилище приложения,
  /// а Permission.storage на Android 13+ всегда возвращает отказ.
  static Future<File?> download(
      {required String url, void Function(int, int)? callback}) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = url.split('/').last;
    final savePath = '${dir.path}/$fileName';

    await ApiService.I.download(url, savePath, onReceiveProgress: callback);

    return File(savePath);
  }
}
