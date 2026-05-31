import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/executor_tile.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({required this.offer, required this.orderId, super.key});
  final int orderId;
  final OfferModel offer;

  Null Function() _onTap(BuildContext context) => () {
        context.router
            .push(DetailsOfferRoute(orderId: orderId, offerId: offer.id));
      };

  Null Function() _createChat(BuildContext context) => () {
        if (offer.executor?.id == null) return;
        context.read<ChatCubit>().createChatOrder(orderId, offer.executor!.id);
      };

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            if (offer.executor != null) ExecutorTile(executor: offer.executor!),
            DataTile(
                title: AppLocalizations.of(context)!.description2,
                data: offer.comment ??
                    AppLocalizations.of(context)!.no_description),
            DataTile(
                title: AppLocalizations.of(context)!.terms, data: offer.date),
            DataTile(
                title: AppLocalizations.of(context)!.price2, data: offer.price),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                    child: OutlinedButtonApp(
                        text: AppLocalizations.of(context)!.createChat,
                        onPressed: _createChat(context))),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButtonApp(
                        text: AppLocalizations.of(context)!.more_details,
                        onPressed: _onTap(context))),
              ],
            )
          ],
        ),
      );
}
