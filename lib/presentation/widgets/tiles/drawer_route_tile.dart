import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DrawerRouteTile extends StatelessWidget {
  final String text;
  final PageRouteInfo page;

  const DrawerRouteTile({super.key, required this.text, required this.page});

  _onTap(BuildContext context) => () {
    context.router.pop();
    context.router.navigate(page);
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap(context),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text),
      ),
    );
  }

}