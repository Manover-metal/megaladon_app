import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(isMenu: true),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 6,
                  backgroundColor: Colors.grey.shade300,
                ),
                DataTile(title: 'Имя:', data: 'Cергей'),
                DataTile(title: 'Имя:', data: '+7 747 940 0950'),
                DataTile(title: 'Имя:', data: 'г.Караганда'),
                Divider(thickness: 1),
                Text('Данные исполнителя'),
                DataTile(title: 'Организация:', data: 'ТОО “Максимум”'),
                DataTile(title: 'Адрес:', data: 'Казахстан, г. Караганда, ул. Алиханова 25|3, ст. 4'),
                DataTile(title: 'Имя:', data: 'г.Караганда'),
                Divider(thickness: 1),
                Text('Данные магазина'),
                DataTile(title: 'Организация:', data: 'ТОО “Максимум”'),
                DataTile(title: 'Адрес:', data: 'Казахстан, г. Караганда, ул. Алиханова 25|3, ст. 4'),
                DataTile(title: 'Описание:', data: 'г.Листовой металл, трубы, квадрат, профиля, уголок, швеллер'),
                DataTile(title: 'Email:', data: 'mailto@mail.ru'),
                DataTile(title: 'Телефон:', data: '+7 (123) 456-78-91'),
                DataTile(title: 'Сайт:', data: 'steel-astana.kz'),
                Text('Прайс листы'),
                FileDownloadList()

              ],
            ),
          ),
        ),
      ),
    );
  }

}