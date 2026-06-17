import 'dart:io';

import 'package:megaladon/core/dio/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static Future<File?> download(
      {required String url, void Function(int, int)? callback}) async {
    final hasPermission = await _requestWritePermission();
    if (!hasPermission) return null;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = url.split('/').last;
    final savePath = '${dir.path}/$fileName';

    await ApiService.I.download(url, savePath, onReceiveProgress: callback);

    return File(savePath);
  }

  static Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}
