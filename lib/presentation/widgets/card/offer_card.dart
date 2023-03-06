import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class OfferCard extends StatelessWidget {

  final OfferModel offer;

  const OfferCard({super.key, required this.offer});

  _onTap(BuildContext context) => () {
    context.router.push(DetailsOfferRoute(orderId: 1, offerId: offer.id));
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
          DataTile(title: 'Описание: ', data: offer.comment ?? ''),
          DataTile(title: 'Сроки: ', data: offer.date),
          DataTile(title: 'Цена: ', data: offer.price),
          SizedBox(
            height: 30,
          ),
          ElevatedButtonApp(text: 'Подробнее', onPressed: _onTap(context),),
        ],
      ),
    );
  }

}