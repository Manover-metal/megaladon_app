import 'package:flutter/material.dart';

/// Заголовок раздела: мелкая прописная подпись над содержимым. Экраны заказа
/// и объявления раньше были сплошными колонками без группировки — подписи
/// задают, где кончается одна тема и начинается другая.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
}

/// Контейнер-карточка. Тот же силуэт, что у карточки в ленте: фон tertiary,
/// рамка onTertiary (цвет обводки полей ввода — единственный оттенок,
/// различимый в обеих темах), радиус 10.
class CardBox extends StatelessWidget {
  const CardBox({
    required this.child,
    this.padding = const EdgeInsets.all(13),
    super.key,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.onTertiary),
      ),
      child: child,
    );
  }
}

/// Подпись + содержимое одним блоком.
class ContentSection extends StatelessWidget {
  const ContentSection({
    required this.title,
    required this.child,
    this.boxed = true,
    this.padding,
    super.key,
  });
  final String title;
  final Widget child;

  /// Поля внутри карточки. Список строк с разделителями во всю ширину
  /// передаёт сюда [EdgeInsets.zero].
  final EdgeInsetsGeometry? padding;

  /// Обернуть содержимое в карточку. Выключается там, где содержимое само
  /// состоит из карточек или миниатюр — двойная рамка читается как рябь.
  final bool boxed;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title),
          const SizedBox(height: 8),
          if (boxed)
            CardBox(
              padding: padding ?? const EdgeInsets.all(13),
              child: child,
            )
          else
            child,
        ],
      );
}
