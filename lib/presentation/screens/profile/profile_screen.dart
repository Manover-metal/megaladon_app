import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/list/file_download_list.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';
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
                DataTile(title: 'Имя: ', data: 'Cергей'),
                DataTile(title: 'Номер: ', data: '+7 747 940 0950'),
                DataTile(title: 'Местоположение: ', data: 'г.Караганда'),
                Divider(thickness: 1),
                TitleApp('Данные исполнителя'),
                SizedBox(height: 20,),

                DataTile(title: 'Организация: ', data: 'ТОО “Максимум”'),
                DataTile(title: 'Адрес: ', data: 'Казахстан, г. Караганда, ул. Алиханова 25|3, ст. 4'),
                DataTile(title: 'Имя: ', data: 'г.Караганда'),
                Divider(thickness: 1),
                TitleApp('Данные магазина'),
                SizedBox(height: 20,),

                DataTile(title: 'Организация: ', data: 'ТОО “Максимум”'),
                DataTile(title: 'Адрес: ', data: 'Казахстан, г. Караганда, ул. Алиханова 25|3, ст. 4'),
                DataTile(title: 'Описание: ', data: 'г.Листовой металл, трубы, квадрат, профиля, уголок, швеллер'),
                DataTile(title: 'Email: ', data: 'mailto@mail.ru'),
                DataTile(title: 'Телефон: ', data: '+7 (123) 456-78-91'),
                DataTile(title: 'Сайт: ', data: 'steel-astana.kz'),
                SizedBox(height: 20,),
                SubTitleApp('Прайс листы', textAlign: TextAlign.start,),
                SizedBox(height: 10,),
                FileDownloadList(),
                SizedBox(height: 20,),

              ],
            ),
          ),
        ),
      ),
    );
  }

}