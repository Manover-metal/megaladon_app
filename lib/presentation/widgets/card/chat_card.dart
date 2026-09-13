import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/badge/unread_badge.dart';
import 'package:megaladon/presentation/widgets/chat/companion_avatar.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    required this.chat,
    super.key,
  });
  final ChatModel chat;

  void Function() _onTap(BuildContext context) => () {
        context.router.navigate(DetailsChatRouter(chat: chat));
      };

  /// Превью последнего сообщения. Сообщения отсортированы по возрастанию,
  /// поэтому свежее — последнее в списке.
  String _preview(BuildContext context) {
    final text = chat.messages.isNotEmpty
        ? chat.messages.last.text
        : chat.lastMessage;
    return (text == null || text.isEmpty)
        ? AppLocalizations.of(context)!.noMessagesInChat
        : text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final companionName = chat.companion?.name ?? '';
    final title = companionName.isNotEmpty
        ? companionName
        : AppLocalizations.of(context)!.chat_unknown_companion;

    // Material несёт фон, скругление и клип, InkWell — внутри с тем же
    // радиусом: так ripple рисуется поверх фона и обрезается по скруглению,
    // а не протекает в область margin.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _onTap(context),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CompanionAvatar(
                      photoUrl: chat.companion?.photoUrl, size: 50),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _preview(context),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          // Непрочитанное превью выделяем начертанием и цветом:
                          // бейдж справа виден не всегда — превью может занять
                          // обе строки и увести взгляд вниз.
                          style: chat.hasUnread
                              ? TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.bodyMedium?.color,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                // Отступы вместе с бейджем: без непрочитанных превью должно
                // дотягиваться до правого края, как раньше.
                if (chat.hasUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: UnreadBadge(count: chat.unreadCount),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
