import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/store_tile.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({required this.store, super.key});
  final StoreModel store;

  Null Function() _onTap(BuildContext context) => () {
        context.router.push(DetailsStoreRoute(storeId: store.id));
      };

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          onTap: _onTap(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                StoreTile(store: store),
                const SizedBox(
                  height: 5,
                ),
                DataTile(
                    title: AppLocalizations.of(context)!.rating2,
                    data: store.rating?.toString() ??
                        AppLocalizations.of(context)!.noRatings),
                DataTile(
                    title: AppLocalizations.of(context)!.location2,
                    data: store.fullAddress),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
}
