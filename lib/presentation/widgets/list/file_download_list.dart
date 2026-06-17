import 'package:flutter/material.dart';
import 'package:megaladon/core/download/download_service.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:share_plus/share_plus.dart';

class FileDownloadList extends StatefulWidget {
  const FileDownloadList({required this.files, super.key});
  final List<FileModel> files;

  @override
  State<FileDownloadList> createState() => _FileDownloadListState();
}

class _FileDownloadListState extends State<FileDownloadList> {
  Future<void> Function() _download(FileModel file) => () async {
        try {
          final downloadFile = await DownloadService.download(
              url: file.url,
              callback: (prog, gres) {
                print('$prog, $gres');
              });

          if (downloadFile == null) return;

          await SharePlus.instance.share(
            ShareParams(files: [XFile(downloadFile.path)]),
          );
        } catch (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось загрузить файл')),
          );
        }
      };

  @override
  Widget build(BuildContext context) => Column(
        children: widget.files
            .where((file) => file.active)
            .map((file) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    IconButton(
                        onPressed: _download(file),
                        icon: const Icon(Icons.share))
                  ],
                ))
            .toList(),
      );
}
