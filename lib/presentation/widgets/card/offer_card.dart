import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class OfferCard extends StatelessWidget {

  _onTap(BuildContext context) => () {
    context.router.push(const DetailsOfferRoute());
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ExecutorTile(),
          DataTile(title: 'Описание: ', data: 'Как принято считать, непосредственные участники технического прогресса объединены в целые кластеры'),
          DataTile(title: 'Сроки: ', data: '2 недели'),
          DataTile(title: 'Цена: ', data: '25 000 ₸'),
          SizedBox(
            height: 30,
          ),
          ElevatedButtonApp(text: 'Подробнее', onPressed: _onTap(context),),
        ],
      ),
    );
  }

}