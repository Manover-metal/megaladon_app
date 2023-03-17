import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class OfferCard extends StatelessWidget {
  final int orderId;
  final OfferModel offer;

  const OfferCard({super.key, required this.offer, required this.orderId});

  _onTap(BuildContext context) => () {
    context.router.push(DetailsOfferRoute(orderId: orderId, offerId: offer.id));
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
          if(offer.executor != null) ExecutorTile(executor: offer.executor!),
          DataTile(title: 'Описание: ', data: offer.comment ?? 'Нет описания'),
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