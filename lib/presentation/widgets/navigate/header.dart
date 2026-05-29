import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class HeaderAppBar extends StatelessWidget {
  const HeaderAppBar(
      {super.key,
      this.padding = const EdgeInsets.only(bottom: 30, top: 10),
      this.isMenu = false,
      this.isBack = false,
      this.onTrailing,
      this.title,
      this.trailing});
  final bool isBack;
  final bool isMenu;
  final String? title;

  final VoidCallback? onTrailing;

  final EdgeInsets padding;
  final Widget? trailing;

  Null Function() _back(BuildContext context) => () {
        context.router.pop();
      };

  Null Function() _showDrawer(BuildContext context) => () {
        getItApp.get<GlobalKey<ScaffoldState>>().currentState?.openDrawer();
      };

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isMenu)
              GestureDetector(
                onTap: _showDrawer(context),
                child: const Icon(
                  Icons.menu,
                  size: 30,
                ),
              )
            else if (isBack)
              GestureDetector(
                onTap: _back(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                ),
              )
            else
              Container(),
            Expanded(child: TitleApp(title ?? '')),
            if (onTrailing != null)
              GestureDetector(
                onTap: onTrailing,
                child: (trailing == null)
                    ? const Icon(
                        Icons.more_horiz,
                        size: 30,
                      )
                    : trailing,
              )
            else
              Container(width: 30)
          ],
        ),
      );
}
