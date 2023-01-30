import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/screens/forms/offer/create_offer_screen.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/tiles/user_tile.dart';

class DetailsAdScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      HeaderAppBar(isBack: true, ),
                      Text('Объявление'),
                      Text('Изготовить скользящие опоры DN-5000 под стойки опорных башней очень большой заголовок задания'),
                      Text('Учитывая ключевые сценарии поведения, синтетическое тестирование требует от нас анализа системы массового участия. Есть над чем задуматься: предприниматели в сети интернет освещают чрезвычайно интересные особенности картины в целом, однако.'),
                      Text('Прикреплённые файлы'),
                      FileDownloadList(),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text('Цена: до 25 000 ₸'),
                      UserTile(),
                      ...[
                        ElevatedButtonApp(
                          text: 'Позвонить',
                        ),
                        OutlinedButtonApp(text: 'Задать вопрос в чате'),
                      ],
                      ...[
                        ElevatedButtonApp(
                          text: 'Изменить',
                        ),
                      ]
                    ],
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

}