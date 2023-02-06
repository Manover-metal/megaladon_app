import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/ad_tile.dart';

class AdCard extends StatelessWidget {

  _onTap(BuildContext context) => () {
    context.router.push(const DetailsAdRoute());
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdTile(),
              SizedBox(height: 5,),

              Text('Учитывая ключевые сценарии поведения, синтетическое тестирование требует от нас анализа системы массового участия....'),
              SizedBox(height: 10,),
              Text('Цена: 25 000 ₸',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorSchemeApp.success.color,
                  fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }

}