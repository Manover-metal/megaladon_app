import 'package:flutter/material.dart';

/// Нижняя шторка выбора одного значения — язык, тема. Заменяет
/// `DropdownButton`, который без декора читался как незаполненное поле
/// формы, а не как текущее значение настройки.
class SettingsOptionSheet<T> extends StatelessWidget {
  const SettingsOptionSheet({
    required this.title,
    required this.options,
    required this.current,
    required this.labelOf,
    super.key,
  });

  final String title;
  final List<T> options;
  final T current;
  final String Function(T value) labelOf;

  /// Открыть шторку и вернуть выбранное значение. null — закрыли, не выбрав.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<T> options,
    required T current,
    required String Function(T value) labelOf,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        useRootNavigator: true,
        useSafeArea: true,
        builder: (_) => SettingsOptionSheet<T>(
          title: title,
          options: options,
          current: current,
          labelOf: labelOf,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
          for (final option in options)
            InkWell(
              onTap: () => Navigator.of(context).pop(option),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        labelOf(option),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: option == current
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: option == current
                              ? scheme.primary
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                    if (option == current)
                      Icon(Icons.check, size: 20, color: scheme.primary),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
