import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/download/download_service.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Полноэкранный просмотр картинки с зумом и кнопкой «сохранить». Начинался
/// как виджет чата (ChatImageViewer), но ничего от чата в нём нет — теперь
/// его же открывают вложения заказа, где кнопка скачивания раньше висела
/// поверх самой картинки.
class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen({required this.url, super.key});
  final String url;

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  bool _busy = false;

  Future<void> _share() async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      final file = await DownloadService.download(url: widget.url);
      if (file == null) return;

      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.unknown_error)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: _busy ? null : _share,
              icon: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.download, color: Colors.white),
            ),
          ],
        ),
        body: Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(imageUrl: widget.url),
          ),
        ),
      );
}
