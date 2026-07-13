import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Круглый аватар собеседника. Если фото нет или оно не загрузилось —
/// показывает иконку-заглушку.
class CompanionAvatar extends StatelessWidget {
  const CompanionAvatar({
    required this.photoUrl,
    this.size = 40,
    super.key,
  });

  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Theme.of(context).colorScheme.tertiary,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
    return ClipOval(
      child: SizedBox(
        height: size,
        width: size,
        child: (photoUrl == null || photoUrl!.isEmpty)
            ? placeholder
            : CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                placeholder: (context, url) => placeholder,
                errorWidget: (context, url, error) => placeholder,
              ),
      ),
    );
  }
}
