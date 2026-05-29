import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DrawerRouteTile extends StatelessWidget {
  const DrawerRouteTile({required this.text, required this.page, super.key});
  final String text;
  final PageRouteInfo page;

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
          child: Text(text),
        ),
      );
}
