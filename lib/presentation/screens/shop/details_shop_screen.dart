import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class DetailsShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(isBack: true),
                Text('TOO "Стальной Алхимик"'),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 6,
                  backgroundColor:  Colors.grey.shade300,
                ),
                DataTile(title: 'Адрес:', data: 'Республика Казахстан, г. Караганда, ул. Заводская 17/2'),
                DataTile(title: 'Email:', data: 'mailto@mail.ru'),
                DataTile(title: 'Телефон:', data: '+7 (123) 456-78-91'),
                DataTile(title: 'Сайт:', data: 'steel-astana.kz'),
                DataTile(title: 'Описание:', data: 'Как принято считать, непосредственные участники технического прогресса объединены в целые кластеры'),
                Text('Прайс Лист'),
                FileDownloadList(),
                ElevatedButtonApp(text: 'Позвонить'),
                OutlinedButtonApp(text: 'Написать'),

              ],
            ),
          ),
        ),
      ),
    );
  }

}