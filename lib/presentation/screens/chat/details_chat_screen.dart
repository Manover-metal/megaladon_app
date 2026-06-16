import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

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

  @override
  void initState() {
    context.read<ChatCubit>().getMessages(widget.chat.id);
    _textController = TextEditingController();
    _focusNode = FocusNode();

    _scrollController = ScrollController();
    _scrollController.addListener(_listenScroll);

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_listenScroll);

    super.dispose();
  }

  void _sendMessage() {
    context
        .read<ChatCubit>()
        .sendMessage(widget.chat, _textController.value.text)
        .then((val) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration.zero,
        curve: Curves.easeOut,
      );
    });
    _textController.clear();
    _focusNode.requestFocus();
  }

  void _listenScroll() {
    if (_scrollController.position.pixels <= 0) {
      context.read<ChatCubit>().getMessages(widget.chat.id);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: HeaderAppBar(
            isBack: true, title: AppLocalizations.of(context)!.chat),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: TextField(
                controller: _textController,
              )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                child: IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(
                      Icons.near_me_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ),
            ],
          ),
        ),
        body: CupertinoScrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
              builder: (context, authState) =>
                  BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  var messages = state.chats
                      .firstWhere((element) => element.id == widget.chat.id)
                      .messages;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        if (messages.isEmpty)
                          Text(AppLocalizations.of(context)!.noMessagesInChat),
                        ...messages.map((e) {
                          var isMe = e.user?.id == authState.user?.id ||
                              e.user?.id == null;
                          return message(context, e, isMe);
                        }).toList(),
                        if (state.loadingMessages[widget.chat.id] != null)
                          ...state.loadingMessages[widget.chat.id]!
                              .map((value) => message(context, value, true))
                              .toList(),
                        if (state.errorMessages[widget.chat.id] != null)
                          ...state.errorMessages[widget.chat.id]!
                              .map((value) =>
                                  message(context, value, true, true))
                              .toList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

  Row message(BuildContext context, MessageModel message, bool isMe,
          [bool isError = false]) =>
      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: !isMe
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
              ),
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: BlocBuilder<ProfileScreenCubit,
                                ProfileScreenState>(
                              builder: (context, state) {
                                var photo = (isMe
                                        ? state.user?.photo
                                        : message.user?.photo) ??
                                    '';
                                return CachedNetworkImage(
                                  imageUrl: photo,
                                  fadeInDuration: Duration.zero,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) => Icon(
                                          Icons.person,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4),
                                  errorWidget: (context, url, error) => Icon(
                                      Icons.person,
                                      size: MediaQuery.of(context).size.width /
                                          4),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                          builder: (context, state) {
                            var name = (isMe
                                    ? state.user?.name
                                    : message.user?.name) ??
                                '';
                            return Text(
                              name,
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(message.text ?? ''),
                  ),
                  Visibility(
                    visible: isError,
                    child: const Positioned(
                        right: 0,
                        child: Icon(Icons.error_outline_rounded,
                            color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
