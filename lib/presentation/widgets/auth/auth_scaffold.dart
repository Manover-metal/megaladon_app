import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/form/field_style.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';

/// Общая оболочка экранов входа и регистрации.
///
/// Раньше каждый из них был `Column` со `Spacer` сверху и снизу: содержимое
/// не прокручивалось, и форма регистрации с пятью полями на невысоком экране
/// с открытой клавиатурой упиралась в полосу переполнения. Здесь тело —
/// `SliverFillRemaining(hasScrollBody: false)`: на высоком экране `footer`
/// прижат к низу, на низком всё честно прокручивается.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.children,
    super.key,
    this.title,
    this.isBack = true,
    this.footer,
  });

  /// Содержимое экрана сверху вниз.
  final List<Widget> children;

  /// Заголовок шапки. Без него шапки нет вовсе — так устроен вход, где
  /// возвращаться некуда.
  final String? title;

  /// Стрелка «назад» в шапке.
  final bool isBack;

  /// Прижимается к низу экрана: дисклеймер соглашения, подсказка.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final hasHeader = title != null;

    return Scaffold(
      appBar: hasHeader
          ? HeaderAppBar(isBack: isBack, compactTitle: true, title: title)
          : null,
      body: SafeArea(
        // Верхний отступ у экрана с шапкой уже забрал AppBar.
        top: !hasHeader,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, hasHeader ? 8 : 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...children,
                    if (footer != null) ...[
                      const Spacer(),
                      const SizedBox(height: 20),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Заголовок экрана: крупная строка и пояснение под ней. Пояснение отвечает
/// на вопрос «что от меня хотят» до того, как человек ткнёт в первое поле.
class AuthHeading extends StatelessWidget {
  const AuthHeading({required this.title, super.key, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.15,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 13,
              height: 1.35,
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Поля, собранные в одну карточку. Внутри карточки поля рисуются без
/// собственной заливки и с нейтральной рамкой — см. [FieldStyle].
class AuthFieldGroup extends StatelessWidget {
  const AuthFieldGroup({required this.children, super.key, this.title});
  final List<Widget> children;

  /// Подпись над карточкой: «Контакты», «Услуги».
  final String? title;

  @override
  Widget build(BuildContext context) {
    final box = FieldStyle(
      neutral: true,
      child: CardBox(
        padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );

    if (title == null) return box;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(title!),
        const SizedBox(height: 8),
        box,
      ],
    );
  }
}

/// Пояснение с иконкой: зачем приложению геопозиция, чем обернётся выбор.
/// Раньше про геопозицию человек узнавал только из снекбара с ошибкой —
/// после того, как заполнил всю форму.
class AuthNote extends StatelessWidget {
  const AuthNote({
    required this.icon,
    required this.title,
    required this.text,
    super.key,
  });
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.onTertiary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: scheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
