import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class ExecutorCard extends StatelessWidget {

  final ExecutorModel executor;

  const ExecutorCard({super.key, required this.executor});

  _onTapDetails(BuildContext context) => () {
    // context.router.push(DetailsOfferRoute(orderId: 1));
  };

  _onTapChat(BuildContext context) => () {
    context.router.push(const DetailsChatRouter());
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
          ExecutorTile(executor: executor),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButtonApp(text: 'Подробнее', onPressed: _onTapDetails(context))
              ),
              const SizedBox(width: 10,),
              Expanded(
                  child: OutlinedButtonApp(
                      text: 'Чат',
                      onPressed: _onTapChat(context)
                  )
              )
            ],
          )
        ],
      ),
    );
  }

}