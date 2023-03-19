import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/presentation/routing/router.dart';

class OrderCard extends StatelessWidget {

  final OrderModel order;

  const OrderCard({super.key, required this.order});

  _onTap(BuildContext context) => () {
    context.router.push(DetailsOrderRoute(orderId: order.id));
  };

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        const SizedBox(width: 10,),
                        Text('Предложений: ${order.countOffers}')
                      ],
                    ),
                    const SizedBox(height: 10,),

                  ],
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.background,
                width: double.infinity,
                height: 2,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(order.createdAt, textAlign: TextAlign.center,)
                      )
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      width: 2,
                    ),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(order.statusName, textAlign: TextAlign.center,)
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}