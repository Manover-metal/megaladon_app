import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

class DetailsChatScreen extends StatefulWidget {
  final ChatModel chat;
  const DetailsChatScreen({super.key, required this.chat});

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

  _sendMessage() {
    context.read<ChatCubit>().sendMessage(widget.chat, _textController.value.text).then((val) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration.zero,
        curve: Curves.easeOut,
      );
    });
    _textController.clear();
    _focusNode.requestFocus();

  }

  _listenScroll() {
    if(_scrollController.position.pixels <= 0) {
      context.read<ChatCubit>().getMessages(widget.chat.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              CupertinoScrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      return BlocBuilder<ChatCubit, ChatState>(
                        builder: (context, state) {
                          List<MessageModel> messages = state.chats.firstWhere((element) => element.id == widget.chat.id).messages;
                          return Column(
                            children: [
                              ...messages.map((e) {
                                bool isMe = false;
                                if(authState is AuthLoginState) {
                                  isMe = e.user?.id == authState.auth.user.value?.id || e.user?.id == null;
                                }
                                return message(context, e, isMe);
                              }).toList(),
                              if(state.loadingMessages[widget.chat.id] != null) ...state.loadingMessages[widget.chat.id]!.map((value) {
                                return message(
                                    context, value, true
                                );
                              }).toList(),
                              if(state.errorMessages[widget.chat.id] != null) ...state.errorMessages[widget.chat.id]!.map((value) {
                                return message(
                                    context, value, true, true
                                );
                              }).toList()
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  child: HeaderAppBar(isBack: true, title: "Chat".tr())
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: TextField(
                      controller: _textController,
                    )),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(
                            Icons.near_me_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          )
                      ),
                    ),
                  ],
                )
              )


            ],
          ),
        ),
      ),
    );
  }


  Row message(BuildContext context, MessageModel message, bool isMe, [bool isError = false]) {
    return Row(
      mainAxisAlignment: isMe?  MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: !isMe? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(
              maxWidth:  MediaQuery.of(context).size.width * 0.8,
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
                        child: Container(
                          height: 40,
                          width: 40,
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              String photo = '';
                              if(state is AuthLoginState) {
                                photo = (isMe ? state.auth.user.value?.photo : message.user?.photo) ?? '';
                              } else {
                                photo = message.user?.photo ?? '';
                              }
                              print(photo);
                              return CachedNetworkImage(
                                imageUrl: photo,
                                fadeInDuration: Duration.zero,
                                progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 4),
                                errorWidget: (context, url, error) => Icon(Icons.person, size: MediaQuery.of(context).size.width / 4),
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          String name = '';
                          if(state is AuthLoginState) {
                            name = (isMe ? state.auth.user.value?.name : message.user?.name) ?? '';
                          } else {
                            name = message.user?.name ?? '';
                          }
                          return Text(
                            name,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                      message.text ?? ''
                  ),
                ),
                Visibility(
                  visible: isError,
                  child: Positioned(
                      right: 0,
                      child: Icon(Icons.error_outline_rounded, color: Colors.red)
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
