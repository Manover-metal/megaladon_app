import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/download/download_service.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';

class FileDownloadList extends StatefulWidget {

  final List<FileModel> files;

  const FileDownloadList({super.key, required this.files});

  @override
  State<FileDownloadList> createState() => _FileDownloadListState();
}

class _FileDownloadListState extends State<FileDownloadList> {

  _download(FileModel file) => () async {
    DownloadService.download(url: file.url);
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.files.map((file) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
            ),
            IconButton(
                onPressed: _download(file),
                icon: const Icon(Icons.download)
            )

          ],
        );
      }).toList(),
    );
  }
}