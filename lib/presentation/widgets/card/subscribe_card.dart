import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/subscribe/subscribe_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';

class SubscribeCard extends StatelessWidget {
  const SubscribeCard({required this.subscribe, super.key});
  final SubscribeModel subscribe;

  @override
  Widget build(BuildContext context) =>
      BlocListener<SubscribeCubit, SubscribeState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is SubscribeSuccess) {
            CustomSnackBar.success(
              Text(l10n.subscribed_for_days(state.subscribe.duration)),
            ).view(context);
          } else if (state is SubscribeError) {
            CustomSnackBar.error(
              Text(state.error.messages.isNotEmpty
                  ? state.error.messages.first
                  : l10n.unknown_error),
            ).view(context);
          }
        },
        child: _SubscribeCardBody(subscribe: subscribe),
      );
}

class _SubscribeCardBody extends StatelessWidget {
  const _SubscribeCardBody({required this.subscribe});
  final SubscribeModel subscribe;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DataTile(
                title: AppLocalizations.of(context)!.price,
                data: AppLocalizations.of(context)!
                    .tenge_price(subscribe.price.toString())),
            DataTile(
                title: AppLocalizations.of(context)!.period,
                data: AppLocalizations.of(context)!
                    .days_count(subscribe.duration)),
            const SizedBox(height: 10),
            ElevatedButtonApp(
              text: subscribe.price == 0.0
                  ? AppLocalizations.of(context)!.activate_for_free
                  : AppLocalizations.of(context)!.buy,
              onPressed: () => context.read<SubscribeCubit>().buy(subscribe),
            ),
          ],
        ),
      );
}
