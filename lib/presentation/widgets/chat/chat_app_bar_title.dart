import 'package:flutter/material.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/presentation/widgets/chat/companion_avatar.dart';

/// Заголовок AppBar экрана переписки: аватар и имя собеседника.
/// Если собеседник неизвестен — показывает [fallbackTitle].
class ChatAppBarTitle extends StatelessWidget {
  const ChatAppBarTitle({
    required this.companion,
    required this.fallbackTitle,
    this.onTap,
    super.key,
  });

  final ChatCompanion? companion;
  final String fallbackTitle;

  /// Переход на профиль собеседника. null — заголовок не нажимается.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name =
        companion?.name.isNotEmpty == true ? companion!.name : fallbackTitle;
    final title = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CompanionAvatar(photoUrl: companion?.photoUrl),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );

    if (onTap == null) return title;
    // HitTestBehavior.opaque: без него тап проваливается в промежутке между
    // аватаром и текстом — Row там прозрачный. Зона нажатия ограничена самой
    // строкой (у Row стоит mainAxisSize.min), а не всей шириной шапки.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: title,
    );
  }
}
