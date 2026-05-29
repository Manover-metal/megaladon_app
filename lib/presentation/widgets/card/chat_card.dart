import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/presentation/routing/router.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    required this.chat,
    super.key,
  });
  final ChatModel chat;

  Null Function() _onTap(BuildContext context) => () {
        context.router.navigate(DetailsChatRouter(chat: chat));
      };

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: _onTap(context),
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          // height: MediaQuery.of(context).size.height / 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('assets/logo/logo.png'),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.title,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                        chat.messages.isNotEmpty
                            ? chat.messages[0].text!
                            : chat.lastMessage ?? 'Нет сообщений',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
