import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/store_model.dart';

class StoreTile extends StatelessWidget {
  const StoreTile({required this.store, super.key});
  final StoreModel store;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.height / 10,
                height: MediaQuery.of(context).size.height / 10,
                color: Theme.of(context).colorScheme.secondary,
                child: CachedNetworkImage(
                  imageUrl: store.photo ?? '',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Icon(IconPack.market,
                          size: MediaQuery.of(context).size.width / 10),
                  errorWidget: (context, url, error) => Icon(IconPack.market,
                      size: MediaQuery.of(context).size.width / 10),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(flex: 8, child: Text(store.name ?? ''))
          ],
        ),
      );
}
