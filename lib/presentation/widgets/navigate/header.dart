import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/icons/my_icon_icons.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';

class HeaderAppBar extends StatelessWidget {

  final bool isBack;
  final bool isMenu;

  final VoidCallback? onTrailing;

  final EdgeInsets padding;

  const HeaderAppBar({
    super.key,
    this.padding = const EdgeInsets.only(bottom: 30, top: 10),
    this.isMenu = false,
    this.isBack = false,
    this.onTrailing
  });

  _back(BuildContext context) => () {
    context.router.pop();
  };

  _showDrawer(BuildContext context) => () {
    getItApp.get<GlobalKey<ScaffoldState>>().currentState?.openDrawer();
  };

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           if(isMenu) GestureDetector(
              onTap: _showDrawer(context),
              child: const Icon(
                MyIcon.menu,
                size: 30,
              ),
            )
          else if(isBack) GestureDetector(
              onTap: _back(context),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
            )
          else Container(),
          Icon(Icons.logo_dev),
          if(onTrailing != null) GestureDetector(
            onTap: _back(context),
            child: const Icon(
              Icons.menu,
              size: 30,
              color: Colors.black,
            ),
          ) else Container()
        ],
      ),
    );
  }

}