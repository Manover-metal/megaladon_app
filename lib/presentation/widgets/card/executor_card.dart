import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class ExecutorCard extends StatelessWidget {

  _onTapDetails(BuildContext context) => () {
    // context.router.push(DetailsOfferRoute(orderId: 1));
  };

  _onTapChat(BuildContext context) => () {
    // context.router.push(DetailsOfferRoute(orderId: 1));
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
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButtonApp(text: 'Подробнее', onPressed: _onTapDetails(context))
              ),
              SizedBox(width: 10,),
              Expanded(
                  child: OutlinedButtonApp(text: 'Чат', onPressed: _onTapChat(context))
              )
            ],
          )
        ],
      ),
    );
  }

}