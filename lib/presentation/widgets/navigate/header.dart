import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderAppBar(
      {super.key,
      this.isMenu = false,
      this.isBack = false,
      this.onTrailing,
      this.title,
      this.compactTitle = false,
      this.titleWidget,
      this.centerTitle,
      this.backgroundColor,
      this.trailing});
  final bool isBack;
  final bool isMenu;
  final String? title;

  /// Заголовок как в макетах детальных экранов: 17 px, вес w600, цветом
  /// основного текста и прижат влево. По умолчанию остаётся прежний
  /// [TitleApp] — 25 px янтарным по центру, — чтобы не переверстать разом
  /// все экраны, которые ещё не переделаны.
  final bool compactTitle;

  /// Кастомный виджет заголовка. Если задан — используется вместо [title]
  /// (например, аватар + имя собеседника в чате).
  final Widget? titleWidget;

  /// Выравнивание заголовка. null — поведение по умолчанию для платформы.
  final bool? centerTitle;

  /// Фон шапки. null — цвет фона экрана (по умолчанию).
  final Color? backgroundColor;
  final VoidCallback? onTrailing;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.scaffoldBackgroundColor;

    return AppBar(
      backgroundColor: bg,
      surfaceTintColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: compactTitle ? false : centerTitle,
      titleSpacing: compactTitle ? 4 : null,
      leading: isMenu
          ? IconButton(
              icon: const Icon(Icons.menu, size: 30),
              // Ищем корневой Scaffold: drawer висит на AutoTabsScaffold в
              // SplashScreen, а сама шапка стоит во вложенном Scaffold'е
              // экрана таба, поэтому Scaffold.of(context) нашёл бы не тот.
              // Раньше здесь был общий GlobalKey<ScaffoldState> из get_it —
              // из-за него два одновременно живых SplashScreen (старый и
              // новый во время replaceAll) роняли дерево с «Multiple widgets
              // used the same GlobalKey».
              onPressed: () => context
                  .findRootAncestorStateOfType<ScaffoldState>()
                  ?.openDrawer(),
            )
          : isBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 26),
                  onPressed: () => context.router.pop(),
                )
              : null,
      title: titleWidget ??
          (compactTitle
              ? Text(
                  title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                )
              : TitleApp(title ?? '')),
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
}
