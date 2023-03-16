// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class DetailPerformersScreen extends StatelessWidget {
  const DetailPerformersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(5),
      // width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo/logo.png'),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                //  padding: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  children: [
                    DataTile(title: 'Исполнитель:', data: 'ТОО'),
                    DataTile(title: 'Выполнено проектов:', data: '125'),
                    DataTile(title: 'Рейтинг:', data: '4,5 '),
                  ],
                ),
              ),
            ],
          ),
          DataTile(
              title: 'Описание:',
              data:
                  'Как принято считать, непосредственные участники '),
          DataTile(title: 'Сроки::', data: '2 недели'),
          DataTile(title: 'Цена::', data: '25 000 ₸'),
           ElevatedButtonApp(text: 'Подробнее', onPressed: (){},)
        ],
      ),
    );
  }
}
