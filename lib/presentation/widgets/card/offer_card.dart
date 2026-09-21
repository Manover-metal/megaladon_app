import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';

/// Отклик на заказ. Читается как коммерческое предложение: цена заголовком,
/// под ней исполнитель, дальше комментарий во всю ширину. Раньше цена стояла
/// третьей строкой тем же кеглем, что подпись «Описание», а сам комментарий
/// был зажат в правую половину строки и выровнен вправо.
class OfferCard extends StatelessWidget {
  const OfferCard({required this.offer, required this.orderId, super.key});
  final int orderId;
  final OfferModel offer;

  Null Function() _onTap(BuildContext context) => () {
        context.router
            .push(DetailsOfferRoute(orderId: orderId, offerId: offer.id));
      };

  /// Отдаём кнопке Future запроса — она держит крутилку и не принимает
  /// второе нажатие. Переписку открывает ChatOpenListener.
  Future<void> Function() _createChat(BuildContext context) => () async {
        // В отклике приходит UserPresenter::short(), то есть id здесь —
        // пользовательский, а openChatWith его и ждёт.
        final companionId = offer.executor?.id;
        if (companionId == null) return;
        await context.read<ChatCubit>().openChatWith(companionId);
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final executor = offer.executor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.tertiary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.onTertiary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  l10n.priceAmount(offer.priceText),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 9),
                // За что цена — сразу за числом: «за шт.» меняет смысл суммы.
                Flexible(
                  child: Text(
                    [
                      offer.priceType.localize(l10n),
                      if (offer.date.isNotEmpty) offer.date,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                  ),
                ),
                if (offer.isExpired) ...[
                  const SizedBox(width: 8),
                  _Chip(text: l10n.offerExpired),
                ],
              ],
            ),
            if (executor != null) ...[
              const SizedBox(height: 9),
              _Author(executor: executor),
            ],
            const SizedBox(height: 9),
            Text(
              offer.comment ?? l10n.no_description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: scheme.secondary,
              ),
            ),
            const SizedBox(height: 11),
            Container(height: 1, color: scheme.onTertiary),
            const SizedBox(height: 10),
            Row(
              children: [
                // Автор отклика удалил аккаунт — писать ему некуда.
                if (executor?.isDeleted != true) ...[
                  Expanded(
                    child: OutlinedButtonApp(
                      text: l10n.chat,
                      onPressed: _createChat(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButtonApp(
                    text: l10n.more_details,
                    onPressed: _onTap(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Кто предложил: аватар, имя и число заказов одной строкой. Прежний
/// `ExecutorTile` занимал здесь около восьмидесяти пикселей высоты и печатал
/// строку «Рейтинг», которого в отклике всё равно нет.
class _Author extends StatelessWidget {
  const _Author({required this.executor});
  final ExecutorModel executor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final orders = executor.countOrders;

    return InkWell(
      onTap: executor.isDeleted
          ? null
          : () => context.router.push(
                UserProfileRoute(userId: executor.id),
              ),
      child: Row(
        children: [
          Avatar(name: executor.name, photoUrl: executor.photo, size: 32),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  executor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontStyle: executor.isDeleted ? FontStyle.italic : null,
                    color: executor.isDeleted
                        ? theme.disabledColor
                        : theme.textTheme.bodyMedium?.color,
                  ),
                ),
                if (orders != null)
                  Text(
                    l10n.metricOrdersCount(orders.toString()),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: scheme.secondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.onTertiary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.5, height: 1.3, color: scheme.secondary),
      ),
    );
  }
}
