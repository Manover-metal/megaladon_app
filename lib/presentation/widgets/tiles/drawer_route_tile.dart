import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/badge/unread_badge.dart';

class DrawerRouteTile extends StatelessWidget {
  const DrawerRouteTile({
    required this.text,
    required this.page,
    this.badgeCount = 0,
    super.key,
  });
  final String text;
  final PageRouteInfo page;

  /// Счётчик справа от названия пункта. 0 — бейджа нет.
  final int badgeCount;

  Null Function() _onTap(BuildContext context) => () {
        context.router.pop();
        context.router.navigate(page);
      };

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: _onTap(context),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Expanded(child: Text(text)),
              UnreadBadge(count: badgeCount),
            ],
          ),
        ),
      );
}
