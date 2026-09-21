import 'package:flutter/material.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';

class ExecutorTile extends StatelessWidget {
  const ExecutorTile({required this.executor, this.onTap, super.key});
  final ExecutorModel executor;

  /// Куда ведёт нажатие. Не передан — тайл остаётся просто блоком сведений:
  /// он используется и там, где переходить некуда, например в отзыве.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Avatar(
                name: executor.name,
                photoUrl: executor.photo,
                size: MediaQuery.of(context).size.height / 10,
                shape: AvatarShape.rounded,
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
                              text: AppLocalizations.of(context)!
                                  .posted_projects),
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
        ),
      );
}
