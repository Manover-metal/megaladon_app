import 'package:flutter/material.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/presentation/widgets/chat/companion_avatar.dart';

/// Заголовок AppBar экрана переписки: аватар и имя собеседника.
/// Если собеседник неизвестен — показывает [fallbackTitle].
class ChatAppBarTitle extends StatelessWidget {
  const ChatAppBarTitle({
    required this.companion,
    required this.fallbackTitle,
    super.key,
  });

  final ChatCompanion? companion;
  final String fallbackTitle;

  @override
  Widget build(BuildContext context) {
    final name =
        companion?.name.isNotEmpty == true ? companion!.name : fallbackTitle;
    return Row(
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
  }
}
