import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/ad_tile.dart';

class AdCard extends StatelessWidget {

  _onTap(BuildContext context) => () {
    context.router.push(const DetailsAdRoute());
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap(context),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            AdTile(),
            Text('Учитывая ключевые сценарии поведения, синтетическое тестирование требует от нас анализа системы массового участия....'),
            Text('Цена: 25 000 ₸', textAlign: TextAlign.right,)
          ],
        ),
      ),
    );
  }

}