import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/offer_model.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          if(offer.executor != null) ExecutorTile(executor: offer.executor!),
          DataTile(title: 'Description2'.tr(), data: offer.comment ?? 'Нет описания'),
          DataTile(title: 'Terms '.tr(), data: offer.date),
          DataTile(title: 'Price: '.tr(), data: offer.price),
          const SizedBox(
            height: 30,
          ),
          ElevatedButtonApp(text: 'Подробнее', onPressed: _onTap(context),),
        ],
      ),
    );
  }

}