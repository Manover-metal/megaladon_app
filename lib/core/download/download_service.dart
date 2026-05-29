import 'package:megaladon/core/dio/index.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static Future<void> download(
      {required String url, Function(int, int)? callback}) async {
    var hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    var dir = await getApplicationDocumentsDirectory();

    var fileName = url.split('/').last;

    await ApiService.I
        .download(url, '${dir.path}/$fileName', onReceiveProgress: callback);

    OpenFile.open('${dir.path}/$fileName');
  }

  static Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}
