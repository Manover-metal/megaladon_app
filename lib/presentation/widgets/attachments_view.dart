import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/presentation/widgets/image_viewer.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';

/// Вложения: картинки лентой миниатюр, документы — списком со скачиванием.
/// Раньше и заказ, и объявление рисовали каждое изображение на всю ширину
/// без потолка высоты — одно вертикальное фото занимало весь экран.
class AttachmentsView extends StatelessWidget {
  const AttachmentsView({
    required this.images,
    this.files = const [],
    super.key,
  });
  final List<FileModel> images;
  final List<FileModel> files;

  static const double _thumbWidth = 104;
  static const double _thumbHeight = 78;

  void _open(BuildContext context, String url) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => ImageViewerScreen(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = images.where((image) => image.active).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (active.isNotEmpty)
          SizedBox(
            height: _thumbHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: active.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final image = active[index];

                return GestureDetector(
                  onTap: () => _open(context, image.url),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: _thumbWidth,
                      height: _thumbHeight,
                      color: scheme.secondaryContainer,
                      child: CachedNetworkImage(
                        imageUrl: image.url,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (_, __, ___) =>
                            Icon(Icons.image_outlined, color: scheme.secondary),
                        errorWidget: (_, __, ___) => Icon(
                            Icons.broken_image_outlined,
                            color: scheme.secondary),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (active.isNotEmpty && files.isNotEmpty) const SizedBox(height: 12),
        if (files.isNotEmpty) FileDownloadList(files: files),
      ],
    );
  }
}
