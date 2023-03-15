import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/tiles/data_tile.dart';
import 'package:megaladon/presentation/widgets/tiles/store_tile.dart';

class StoreCard extends StatelessWidget {
  final StoreModel store;

  const StoreCard({super.key, required this.store});

  _onTap(BuildContext context) => () {
        context.router.push(DetailsStoreRoute(storeId: store.id));
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: _onTap(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              StoreTile(store: store),
              SizedBox(
                height: 5,
              ),
              DataTile(title: 'Деятельность: ', data: store.type?.name ?? ''),
              DataTile(title: 'Рейтинг: ', data: store.rating!),
              DataTile(title: 'Местоположение: ', data: store.fullAddress),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
