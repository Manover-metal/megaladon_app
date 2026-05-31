import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, super.key});
  final OrderModel order;

  Null Function() _onTap(BuildContext context) => () {
        context.router.push(DetailsOrderRoute(orderId: order.id));
      };

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          onTap: _onTap(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(order.title),
                      Text(order.description),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.people),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(AppLocalizations.of(context)!
                              .offersWithCount(order.countOffers.toString()))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  width: double.infinity,
                  height: 2,
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                order.createdAt,
                                textAlign: TextAlign.center,
                              ))),
                      Container(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                order.statusName,
                                textAlign: TextAlign.center,
                              )))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
