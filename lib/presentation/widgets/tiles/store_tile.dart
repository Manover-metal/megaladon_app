import 'package:flutter/material.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';

class StoreTile extends StatelessWidget {
  const StoreTile({required this.store, super.key});
  final StoreModel store;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Avatar(
              name: store.name ?? '',
              photoUrl: store.photo,
              size: MediaQuery.of(context).size.height / 10,
              shape: AvatarShape.rounded,
              fallbackIcon: IconPack.market,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(flex: 8, child: Text(store.name ?? ''))
          ],
        ),
      );
}
