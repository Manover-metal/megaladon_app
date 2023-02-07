import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/store_tile.dart';

class StoreCard extends StatelessWidget {

  _onTap(BuildContext context) => () {
    context.router.push(const DetailsStoreRoute());
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: _onTap(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              StoreTile(),
              SizedBox(height: 5,),
              DataTile(title: 'Деятельность: ', data: 'Продажа металлопроката'),
              DataTile(title: 'Рейтинг: ', data: '4.5'),
              DataTile(title: 'Местоположение: ', data: 'г, Нур Султан'),
              SizedBox(height: 5,),

            ],
          ),
        ),
      ),
    );
  }

}