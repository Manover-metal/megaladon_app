// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/generated/locale_keys.g.dart';
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
                SizedBox(height: 20,),
                DataTile(title: LocaleKeys.Name.tr(), data: 'Cергей'),
                DataTile(title: LocaleKeys.Telephone.tr() , data: '+7 747 940 0950'),
                DataTile(title: LocaleKeys.Location.tr(), data: 'г.Караганда'),
                Divider(thickness: 1),
                TitleApp(LocaleKeys.Artist_data.tr()),
                SizedBox(height: 20,),

                DataTile(title: LocaleKeys.Organization.tr(), data: 'ТОО “Максимум”'),
                DataTile(title: LocaleKeys.Address, data: 'Казахстан, г. Караганда, ул. Алиханова 25|3, ст. 4'),
                DataTile(title: LocaleKeys.Name, data: 'г.Караганда'),
                Divider(thickness: 1),
                TitleApp(LocaleKeys.Store_data.tr()),
                SizedBox(height: 20,),

                DataTile(title: LocaleKeys.Organization.tr(), data: 'ТОО “Максимум”'),
                DataTile(title: LocaleKeys.Address.tr(), data: 'Казахстан, г. Караганда, ул. Алиханова 25|3, ст. 4'),
                DataTile(title: LocaleKeys.Description.tr(), data: 'г.Листовой металл, трубы, квадрат, профиля, уголок, швеллер'),
                DataTile(title: LocaleKeys.Email.tr(), data: 'mailto@mail.ru'),
                DataTile(title: LocaleKeys.Telephone.tr(), data: '+7 (123) 456-78-91'),
                DataTile(title: LocaleKeys.Website.tr(), data: 'steel-astana.kz'),
                SizedBox(height: 20,),
                SubTitleApp(LocaleKeys.Price_lists.tr(), textAlign: TextAlign.start,),
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