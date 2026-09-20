import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/badge/unread_badge.dart';
import 'package:megaladon/presentation/widgets/card/order_card.dart';

OrderModel _order({bool contentChanged = false}) => OrderModel.fromJsonMini({
      'id': 1,
      'title': 'Заказ',
      'description': 'Описание',
      'count_offers': 0,
      'created_at': '20.09.2026',
      'status': 'Активен',
      'status_code': 2,
      'content_changed': contentChanged,
    });

// OrderCard зовёт AppLocalizations.of(context)! — без делегатов упадёт
// на null check ещё до проверки точки.
Future<void> _pumpCard(WidgetTester tester, OrderModel order) =>
    tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      home: Scaffold(body: OrderCard(order: order)),
    ));

void main() {
  testWidgets('правка заказа зажигает точку на карточке', (tester) async {
    await _pumpCard(tester, _order(contentChanged: true));

    expect(
      tester
          .widgetList<UnreadBadge>(find.byType(UnreadBadge))
          .any((b) => b.count > 0),
      isTrue,
    );
  });

  testWidgets('без изменений точки нет', (tester) async {
    await _pumpCard(tester, _order());

    expect(
      tester
          .widgetList<UnreadBadge>(find.byType(UnreadBadge))
          .every((b) => b.count == 0),
      isTrue,
    );
  });
}
