import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:megaladon/core/image/image_service.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/widgets/chat/chat_app_bar_title.dart';
import 'package:megaladon/presentation/widgets/chat/chat_image_viewer.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsChatScreen extends StatefulWidget {
  const DetailsChatScreen({required this.chat, super.key});
  final ChatModel chat;

  @override
  State<DetailsChatScreen> createState() => _DetailsChatScreenState();
}

class _DetailsChatScreenState extends State<DetailsChatScreen> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late ScrollController _scrollController;
  late ChatCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<ChatCubit>();
    _cubit.openChat(widget.chat.id);
    _textController = TextEditingController();
    _focusNode = FocusNode();

    _scrollController = ScrollController();
    _scrollController.addListener(_listenScroll);

    super.initState();
  }

  @override
  void dispose() {
    _cubit.closeChat();
    _textController.dispose();
    _focusNode.dispose();
    _scrollController
      ..removeListener(_listenScroll)
      ..dispose();

    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.value.text;
    if (text.trim().isEmpty) return;
    // Отправка вставляет сообщение оптимистично (появляется сразу), поэтому
    // спускаемся вниз тут же, не дожидаясь ответа сервера.
    _cubit.sendMessage(widget.chat.id, text);
    _scrollToBottom();
    _textController.clear();
    _focusNode.requestFocus();
  }

  Future<void> _attachFile() async {
    final result = await ImageService.getFile();
    final file = result?.files.elementAtOrNull(0);
    if (file == null || file.bytes == null) return;
    _cubit.sendFile(widget.chat.id, file);
    _scrollToBottom();
  }

  /// Спуск к новейшему сообщению. Список перевёрнут (reverse: true), поэтому
  /// низ — это всегда смещение 0: промахнуться невозможно, значение не
  /// устаревает при смене высоты списка.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _listenScroll() {
    final pos = _scrollController.position;
    // В перевёрнутом списке старые сообщения — у верхнего края, а это
    // maxScrollExtent. Подгружаем историю при подходе к нему.
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _cubit.loadOlder(widget.chat.id);
    }
  }

  /// Немного затемняет цвет (по светлоте), корректно работает и в светлой,
  /// и в тёмной теме. Используется для панели ввода — она должна быть чуть
  /// темнее фона переписки.
  Color _darken(Color color, [double amount = 0.04]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
          isBack: true,
          centerTitle: false,
          backgroundColor: _darken(Theme.of(context).scaffoldBackgroundColor),
          titleWidget: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final chat = state.chats.firstWhere(
                (c) => c.id == widget.chat.id,
                orElse: () => widget.chat,
              );
              return ChatAppBarTitle(
                companion: chat.companion ?? widget.chat.companion,
                fallbackTitle: AppLocalizations.of(context)!.chat,
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          // Панель ввода чуть темнее фона переписки.
          color: _darken(Theme.of(context).scaffoldBackgroundColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: _attachFile,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        minLines: 1,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .ask_a_question_in_the_chat,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.tertiary,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: Icon(
                          Icons.near_me_outlined,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom,)
            ],
          ),
        ),
        body: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
          builder: (context, authState) => BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final chat = state.chats.firstWhere(
                (element) => element.id == widget.chat.id,
                orElse: () => widget.chat,
              );
              final pending =
                  state.loadingMessages[widget.chat.id] ?? const [];
              final failed = state.errorMessages[widget.chat.id] ?? const [];

              // Визуальный порядок сверху вниз: старые → новые, затем
              // отправляемые и неотправленные. Переворачиваем, потому что
              // ListView(reverse: true) кладёт индекс 0 вниз — так новейшее
              // всегда на смещении 0.
              final items = <_ChatItem>[
                ...chat.messages.map((m) => _ChatItem(m,
                    isMe: m.user?.id == authState.user?.id ||
                        m.user?.id == null)),
                ...pending.map((m) =>
                    _ChatItem(m, isMe: true, isUploading: m.fileName != null)),
                ...failed.map((m) => _ChatItem(m, isMe: true, isError: true)),
              ].reversed.toList();

              if (items.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noMessagesInChat),
                );
              }

              return CupertinoScrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return message(
                        context, it.model, it.isMe, it.isError, it.isUploading);
                  },
                ),
              );
            },
          ),
        ),
      );

  // Пузырь сообщения: только текст и время отправки. Мои сообщения справа,
  // собеседника — зеркально слева (другой цвет и «хвостик» на другом углу).
  Widget message(BuildContext context, MessageModel message, bool isMe,
      [bool isError = false, bool isUploading = false]) {
    final time = DateFormat('HH:mm').format(message.createdAt.toLocal());
    final timeColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5);
    final content = _messageContent(context, message, isUploading);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                content,
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isError) ...[
                      const Icon(Icons.error_outline_rounded,
                          color: Colors.red, size: 14),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      time,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 11, color: timeColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageContent(
      BuildContext context, MessageModel message, bool isUploading) {
    if (isUploading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(message.fileName ?? '',
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    }

    final url = message.file;
    // Файл ещё не на сервере (например, неотправленное сообщение): server URL
    // нет, но имя файла есть — показываем строку с именем, а не пустой пузырь.
    // Красный индикатор ошибки рисует внешний message() по isError.
    if (url == null && message.fileName != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(message.fileName!,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    }
    if (url != null && _isImage(message.fileName ?? url)) {
      return GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ChatImageViewer(url: url),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: url,
            width: 200,
            fit: BoxFit.cover,
            placeholder: (_, __) => const SizedBox(
              width: 200,
              height: 120,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) => const SizedBox(
              width: 200,
              height: 120,
              child: Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
      );
    }

    if (url != null) {
      return GestureDetector(
        onTap: () => _openFile(context, url),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(message.fileName ?? '',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      );
    }

    return Text(
      message.text ?? '',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  bool _isImage(String name) {
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    return ext == 'jpg' || ext == 'jpeg' || ext == 'png';
  }

  Future<void> _openFile(BuildContext context, String url) async {
    final ok = await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.file_open_error)),
      );
    }
  }
}

/// Элемент ленты переписки: сообщение плюс флаги отрисовки. Объединяет
/// реальные, отправляемые и неотправленные сообщения в один список для
/// ListView.builder.
class _ChatItem {
  const _ChatItem(this.model,
      {required this.isMe, this.isError = false, this.isUploading = false});

  final MessageModel model;
  final bool isMe;
  final bool isError;
  final bool isUploading;
}
