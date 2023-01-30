import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class DetailsOfferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                HeaderAppBar(
                  isBack: true,
                ),
                Text('Предложение исполнителя'),
                ExecutorTile(),
                SizedBox(height: 20,),
                DataTile(title: 'Актуален до: ', data: '31-10-2022',),
                DataTile(title: 'Цена: ', data: '25 000 ₸',),
                DataTile(title: 'Сроки: ', data: '2 недели',),
                DataTile(title: 'Местоположение: ', data: 'г. Караганда',),
                DataTile(title: 'Описание:  ', data: 'Как принято считать, непосредственные участники технического прогресса объединены в целые кластеры',),
                SizedBox(height: 20,),
                ElevatedButtonApp(text: 'Назначить исполнителем')
              ],
            ),
          ),
        ),
      ),
    );
  }
}