import 'package:flutter/material.dart';

/// Оформление полей ввода внутри поддерева.
///
/// По умолчанию поле рисуется так же, как раньше: заливка
/// [ColorScheme.tertiary] и янтарная обводка [ColorScheme.primary]. Внутри
/// `FieldStyle(neutral: true)` поле становится прозрачным с волосяной рамкой
/// [ColorScheme.onTertiary] — тем же цветом, что у карточек. Так шесть полей,
/// собранных в одну карточку, читаются списком, а не решёткой из акцентного
/// цвета: на форме регистрации магазина янтарных обводок подряд было семь.
///
/// Ошибка важнее оформления — красная рамка рисуется в обоих режимах.
class FieldStyle extends InheritedWidget {
  const FieldStyle({required super.child, this.neutral = false, super.key});

  /// Нейтральное оформление: без заливки, рамка цвета `onTertiary`.
  final bool neutral;

  static bool _neutralOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FieldStyle>()?.neutral ??
      false;

  /// Заливка поля.
  static Color fillOf(BuildContext context) => _neutralOf(context)
      ? Colors.transparent
      : Theme.of(context).colorScheme.tertiary;

  /// Рамка поля.
  static BoxBorder borderOf(BuildContext context, {bool hasError = false}) {
    final scheme = Theme.of(context).colorScheme;
    final neutral = _neutralOf(context);
    final width = neutral ? 1.0 : 0.5;

    if (hasError) return Border.all(color: scheme.error, width: width);

    return Border.all(
      color: neutral ? scheme.onTertiary : scheme.primary,
      width: width,
    );
  }

  @override
  bool updateShouldNotify(FieldStyle oldWidget) => oldWidget.neutral != neutral;
}
