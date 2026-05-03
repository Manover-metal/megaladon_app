import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
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
    context.router.navigate(InitialRouter(
      children: [
        OrderRouter(
          children: [
            DetailsExecutorRoute(executorId: executor.id)
          ]
        )
      ]
    ));
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
                  child: ElevatedButtonApp(text: 'more_details'.tr(), onPressed: _onTapDetails(context))
              ),
              // const SizedBox(width: 10,),
              // Expanded(
              //     child: OutlinedButtonApp(
              //         text: 'Chat'.tr(),
              //         onPressed: _onTapChat(context)
              //     )
              // )
            ],
          )
        ],
      ),
    );
  }

}