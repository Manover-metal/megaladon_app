import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

class ExecutorTile extends StatelessWidget {
  const ExecutorTile({required this.executor, super.key});
  final ExecutorModel executor;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.height / 10,
                height: MediaQuery.of(context).size.height / 10,
                color: Theme.of(context).colorScheme.secondary,
                child: CachedNetworkImage(
                  imageUrl: executor.photo ?? '',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Icon(Icons.person,
                          size: MediaQuery.of(context).size.width / 10),
                  errorWidget: (context, url, error) => Icon(Icons.person,
                      size: MediaQuery.of(context).size.width / 10),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: AppLocalizations.of(context)!.artist2),
                    TextSpan(
                        text: executor.name,
                        style: executor.isDeleted
                            ? TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontStyle: FontStyle.italic)
                            : null)
                  ])),
                  const SizedBox(
                    height: 5,
                  ),
                  // У удалённого аккаунта нет ни счётчика заказов, ни рейтинга —
                  // показываем только имя-заглушку.
                  if (!executor.isDeleted) ...[
                    if (executor.countOrders != null) ...[
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text:
                                AppLocalizations.of(context)!.posted_projects),
                        TextSpan(text: executor.countOrders.toString())
                      ])),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                    Text.rich(TextSpan(children: [
                      TextSpan(text: AppLocalizations.of(context)!.rating2),
                      TextSpan(
                          text: executor.rating?.toString() ??
                              AppLocalizations.of(context)!.noRatings)
                    ]))
                  ],
                ],
              ),
            )
          ],
        ),
      );
}
