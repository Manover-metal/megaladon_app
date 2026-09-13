import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/badge/unread_badge.dart';

/// Пункт меню, ведущий на маршрут. Раньше это была голая строка текста —
/// десять таких подряд читались как сплошная простыня, а активный раздел
/// ничем не отмечался.
class DrawerRouteTile extends StatelessWidget {
  const DrawerRouteTile({
    required this.text,
    required this.page,
    this.icon,
    this.activeRouteName,
    this.badgeCount = 0,
    this.muted = false,
    super.key,
  });
  final String text;
  final PageRouteInfo page;

  final IconData? icon;

  /// Имя маршрута, при котором пункт считается текущим (например
  /// `ListMyOrdersRoute.name`). Сравнивается с самым верхним маршрутом, так
  /// что подсветка гаснет, когда пользователь проваливается в детальный
  /// экран. null — пункт никогда не подсвечивается.
  final String? activeRouteName;

  /// Счётчик справа от названия пункта. 0 — бейджа нет.
  final int badgeCount;

  /// Второстепенный пункт: регистрация второй роли, выход. Тише основных.
  final bool muted;

  Null Function() _onTap(BuildContext context) => () {
        context.router.pop();
        context.router.navigate(page);
      };

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context, watch: true);
    final isActive =
        activeRouteName != null && router.topRoute.name == activeRouteName;

    return DrawerTileBody(
      icon: icon,
      text: text,
      isActive: isActive,
      muted: muted,
      onTap: _onTap(context),
      trailing: UnreadBadge(count: badgeCount),
    );
  }
}

/// Общее тело пункта меню: полоса и заливка у активного, иконка, название,
/// бейдж. Вынесено, чтобы кнопка выхода выглядела так же, как навигация.
class DrawerTileBody extends StatelessWidget {
  const DrawerTileBody({
    required this.text,
    required this.onTap,
    this.icon,
    this.isActive = false,
    this.muted = false,
    this.trailing,
    super.key,
  });
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isActive;
  final bool muted;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = isActive
        ? scheme.primary
        : muted
            ? scheme.secondary
            : theme.textTheme.bodyMedium?.color;

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            color: isActive
                ? scheme.primary.withValues(alpha: 0.10)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 19, color: color),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: color,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          if (isActive)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 3,
                  height: 22,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(2)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
