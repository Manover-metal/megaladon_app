// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
import 'package:megaladon/presentation/widgets/card/chat_card.dart';
import 'package:megaladon/presentation/widgets/card/store_card.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class ListChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      HeaderAppBar(
                        isMenu: true,
                      ),
                      TitleApp('SMS'),
                      SizedBox(
                        height: 20,
                      ),
                      ChatCard()
                    ],
                  ),
                ),
                
                // ChatCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
