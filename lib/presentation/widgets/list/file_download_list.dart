import 'package:flutter/material.dart';
import 'package:megaladon/core/download/download_service.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class FileDownloadList extends StatefulWidget {
  const FileDownloadList({required this.files, super.key});
  final List<FileModel> files;

  @override
  State<FileDownloadList> createState() => _FileDownloadListState();
}

class _FileDownloadListState extends State<FileDownloadList> {
  /// Файлы, которые сейчас скачиваются. Пока файл качается, вместо кнопки
  /// крутилка — второе нажатие не запускает вторую загрузку.
  final Set<FileModel> _downloading = {};

  Future<void> _download(FileModel file) async {
    if (!_downloading.add(file)) return;
    setState(() {});
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fileDownloadFailed)),
      );
    } finally {
      _downloading.remove(file);
      if (mounted) setState(() {});
    }
  }

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
                    if (_downloading.contains(file))
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    else
                      IconButton(
                          onPressed: () => _download(file),
                          icon: const Icon(Icons.share)),
                  ],
                ))
            .toList(),
      );
}
