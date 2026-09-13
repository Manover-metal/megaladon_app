import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/tiles/drawer_route_tile.dart';

/// Пункт меню с произвольным действием — выход из аккаунта. Внешне
/// неотличим от навигационных пунктов, чтобы список читался единым ритмом.
class DrawerTile extends StatelessWidget {
  const DrawerTile({
    required this.text,
    required this.callback,
    this.icon,
    this.muted = false,
    super.key,
  });
  final String text;
  final VoidCallback callback;
  final IconData? icon;
  final bool muted;

  @override
  Widget build(BuildContext context) => DrawerTileBody(
        icon: icon,
        text: text,
        muted: muted,
        onTap: callback,
      );
}
