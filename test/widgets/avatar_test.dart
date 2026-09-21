import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/core/themes/light.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';

Widget _wrap(Widget child, {ThemeData? theme}) =>
    MaterialApp(theme: theme, home: Scaffold(body: child));

double _channel(double v) =>
    v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();

double _luminance(Color c) =>
    0.2126 * _channel(c.r) + 0.7152 * _channel(c.g) + 0.0722 * _channel(c.b);

double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  group('инициалы', () {
    testWidgets('из двух слов — первые буквы обоих', (tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(name: 'Асхат Кенжебаев', photoUrl: null)),
      );

      expect(find.text('АК'), findsOneWidget);
    });

    testWidgets('из одного слова — одна буква', (tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(name: 'Асхат', photoUrl: null)),
      );

      expect(find.text('А'), findsOneWidget);
    });

    // Имена приходят с сервера как есть: двойные пробелы и хвостовые
    // встречаются, и split(' ') даёт на них пустые части.
    testWidgets('лишние пробелы не дают пустых букв', (tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(name: '  Асхат   Кенжебаев  ', photoUrl: null)),
      );

      expect(find.text('АК'), findsOneWidget);
    });

    testWidgets('больше двух слов — только первые два', (tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(name: 'Асхат Кенжебаев Маратович', photoUrl: null)),
      );

      expect(find.text('АК'), findsOneWidget);
    });
  });

  group('пустое имя', () {
    testWidgets('без fallbackIcon — вопросительный знак', (tester) async {
      await tester.pumpWidget(_wrap(const Avatar(name: '', photoUrl: null)));

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('с fallbackIcon — иконка вместо текста', (tester) async {
      await tester.pumpWidget(_wrap(
        const Avatar(name: '', photoUrl: null, fallbackIcon: Icons.storefront),
      ));

      expect(find.byIcon(Icons.storefront), findsOneWidget);
      expect(find.text('?'), findsNothing);
    });
  });

  group('без фотографии в сеть не ходим', () {
    // Пустая строка приходит из моделей чаще, чем null: у photo тип String?,
    // но бэкенд отдаёт "" для незаполненного поля.
    testWidgets('photoUrl == "" — сразу инициалы', (tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(name: 'Асхат Кенжебаев', photoUrl: '')),
      );

      expect(find.text('АК'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  // Пока фото не доехало, во всех списках и на всех экранах должно быть одно
  // и то же: бегущий блик, а не инициалы. Иначе «грузится» неотличимо от
  // «фотографии нет».
  group('загрузка', () {
    testWidgets('незавершённый запрос — shimmer, а не инициалы',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const Avatar(
          name: 'Асхат Кенжебаев',
          photoUrl: 'https://example.invalid/a.png',
        ),
      ));
      await tester.pump();

      expect(find.byType(ShaderMask), findsOneWidget);
      expect(find.text('АК'), findsNothing);
    });
  });

  // Инициалы рисовались цветом scheme.secondary поверх scheme.secondaryContainer,
  // а в тёмной теме это один и тот же #C7C4C2 — текст был в дереве, но его не
  // было видно. Проверяем не наличие Text, а его контраст с фоном круга.
  group('инициалы читаются', () {
    for (final entry in {'светлая': themeLight, 'тёмная': themeDark}.entries) {
      testWidgets('${entry.key} тема: контраст не ниже AA', (tester) async {
        await tester.pumpWidget(_wrap(
          const Avatar(name: 'Асхат Кенжебаев', photoUrl: null),
          theme: entry.value,
        ));

        final label = tester.widget<Text>(find.text('АК'));
        final circle = tester.widget<Container>(
          find.ancestor(of: find.text('АК'), matching: find.byType(Container)),
        );

        final fg = label.style!.color!;
        final bg =
            (circle.color ?? (circle.decoration as BoxDecoration).color)!;

        expect(
          _contrast(fg, bg),
          greaterThanOrEqualTo(4.5),
          reason: 'инициалы $fg на фоне $bg не читаются',
        );
      });
    }
  });

  // Блик должен быть заметен, но не превращаться в чёрную дыру: раньше он брался
  // из scheme.surface, а в тёмной теме это #1E1E1E против светло-серой заливки.
  group('блик shimmer', () {
    for (final entry in {'светлая': themeLight, 'тёмная': themeDark}.entries) {
      test('${entry.key} тема: блик заметен, но не инвертирует круг', () {
        final scheme = entry.value.colorScheme;
        final ratio =
            _contrast(shimmerHighlight(scheme), scheme.secondaryContainer);

        expect(ratio, greaterThan(1.05), reason: 'блик не виден');
        expect(ratio, lessThan(2.0),
            reason: 'блик читается дырой, а не бликом');
      });
    }
  });

  group('форма и размер', () {
    testWidgets('circle по умолчанию', (tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(name: 'Асхат', photoUrl: null, size: 48)),
      );

      expect(find.byType(ClipOval), findsOneWidget);
      expect(tester.getSize(find.byType(Avatar)), const Size(48, 48));
    });

    testWidgets('rounded — прямоугольник со скруглением', (tester) async {
      await tester.pumpWidget(
        _wrap(const Avatar(
          name: 'Асхат',
          photoUrl: null,
          shape: AvatarShape.rounded,
        )),
      );

      expect(find.byType(ClipOval), findsNothing);
      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });
}
