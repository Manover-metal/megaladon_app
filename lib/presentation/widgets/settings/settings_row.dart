import 'package:flutter/material.dart';

/// Строка настройки внутри карточки-секции: иконка, название, текущее
/// значение справа и указатель действия. Раньше каждая настройка была
/// собрана по-своему — `Row` с двумя `Expanded` у языка и темы, `ListTile`
/// у пушей, кнопка во всю ширину у документов, — и ни одна пара строк не
/// совпадала по высоте.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;

  /// Пояснение под названием — состояние переключателя, например.
  final String? subtitle;

  /// Текущее значение настройки справа от названия.
  final String? value;

  /// Что стоит в самом конце строки: шеврон, значок внешней ссылки,
  /// переключатель. null — ничего.
  final Widget? trailing;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
        child: Row(
          children: [
            Icon(icon, size: 19, color: scheme.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.5, color: scheme.secondary),
                    ),
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 10),
              Text(
                value!,
                style: TextStyle(fontSize: 13, color: scheme.secondary),
              ),
            ],
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Разделитель между строками одной карточки.
class SettingsRowDivider extends StatelessWidget {
  const SettingsRowDivider({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        color: Theme.of(context).colorScheme.onTertiary,
      );
}

/// Шеврон и значок внешней ссылки — чтобы строка сама говорила, откроется
/// экран приложения или браузер.
class SettingsChevron extends StatelessWidget {
  const SettingsChevron({this.external = false, super.key});
  final bool external;

  @override
  Widget build(BuildContext context) => Icon(
        external ? Icons.open_in_new : Icons.arrow_forward_ios,
        size: external ? 16 : 14,
        color: Theme.of(context).colorScheme.secondary,
      );
}
