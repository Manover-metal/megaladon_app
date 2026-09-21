import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/card/ad_card.dart';

AdvertModel _advert({int? price, String type = 'service'}) =>
    AdvertModel.fromJsonAll({
      'id': 1,
      'title': 'Токарные работы',
      'description': 'Описание',
      'type': type,
      'price': price,
    });

// AdCard зовёт AppLocalizations.of(context)! — без делегатов упадёт на null
// check ещё до проверки цены.
Future<void> _pumpCard(WidgetTester tester, AdvertModel advert) =>
    tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      home: Scaffold(body: AdCard(advert: advert)),
    ));

bool _hasPriceText(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .any((text) => text.data?.contains('₸') ?? false);

void main() {
  testWidgets('услуга с ценой показывает стартовую цену', (tester) async {
    await _pumpCard(tester, _advert(price: 20000));

    expect(find.text('от 20 000 ₸'), findsOneWidget);
  });

  testWidgets('услуга без цены не показывает строку цены', (tester) async {
    await _pumpCard(tester, _advert());

    expect(_hasPriceText(tester), isFalse);
  });

  testWidgets('объявление без цены не показывает строку цены', (tester) async {
    await _pumpCard(tester, _advert(type: 'advert'));

    expect(_hasPriceText(tester), isFalse);
  });
}
