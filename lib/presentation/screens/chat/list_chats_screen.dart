import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/card/chat_card.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ListChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    HeaderAppBar(
                      isMenu: true,
                      title: 'Чаты',
                    ),
                    Column(
                      children: List.generate(6, (index) => ChatCard()),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
