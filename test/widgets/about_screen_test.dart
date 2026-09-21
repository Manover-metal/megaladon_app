import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/screens/profile/about_screen.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';

Widget _app(Locale locale) => MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AboutScreen(),
    );

void main() {
  // Раньше экран был одним Text с семью абзацами через \n. Проверяем, что
  // разделы существуют как отдельные строки, а не как кусок текста.
  testWidgets('показывает пять разделов приложения', (tester) async {
    await tester.pumpWidget(_app(const Locale('ru')));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    expect(find.text(l10n.tabOrders), findsOneWidget);
    expect(find.text(l10n.tabStores), findsOneWidget);
    expect(find.text(l10n.tabAds), findsOneWidget);
    expect(find.text(l10n.tabProfile), findsOneWidget);
    expect(find.text(l10n.aboutCreateTitle), findsOneWidget);
  });

  // Смысл в том, чтобы подсказка называла вкладки ровно теми словами, что
  // написаны на самих вкладках. Общий ключ — единственная гарантия, что это
  // не разъедется при следующей правке текстов.
  testWidgets('заголовки берутся из подписей вкладок', (tester) async {
    for (final code in ['ru', 'en', 'kk']) {
      await tester.pumpWidget(_app(Locale(code)));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(Locale(code));
      expect(find.text(l10n.tabStores), findsOneWidget,
          reason: 'локаль $code: подпись вкладки «Прокат» не совпала');
    }
  });

  // Поиск сужен до карточки: в шапке живёт своя иконка «назад», и на неё
  // счётчик разделов реагировать не должен.
  testWidgets('у каждого раздела есть иконка', (tester) async {
    await tester.pumpWidget(_app(const Locale('ru')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(CardBox), matching: find.byType(Icon)),
      findsNWidgets(5),
    );
  });
}
