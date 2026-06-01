import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderAppBar(
      {super.key,
      this.isMenu = false,
      this.isBack = false,
      this.onTrailing,
      this.title,
      this.trailing});
  final bool isBack;
  final bool isMenu;
  final String? title;
  final VoidCallback? onTrailing;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: isMenu
            ? IconButton(
                icon: const Icon(Icons.menu, size: 30),
                onPressed: () => getItApp
                    .get<GlobalKey<ScaffoldState>>()
                    .currentState
                    ?.openDrawer(),
              )
            : isBack
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 30),
                    onPressed: () => context.router.pop(),
                  )
                : null,
        title: TitleApp(title ?? ''),
        actions: [
          if (onTrailing != null)
            GestureDetector(
              onTap: onTrailing,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: trailing ?? const Icon(Icons.more_horiz, size: 30),
              ),
            ),
        ],
      );
}
