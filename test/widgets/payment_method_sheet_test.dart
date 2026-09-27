import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/screens/subscribe/widgets/payment_method_sheet.dart';
import 'package:megaladon/presentation/widgets/card/subscribe_card.dart';

Widget _app(Widget child) => MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

final _plan = SubscribeModel(
    id: 1, type: SubscribeType.executor, duration: 1, price: 5000);

void main() {
  testWidgets('показывает магазин с его ценой и менеджера', (tester) async {
    await tester.pumpWidget(_app(const PaymentMethodSheet(
      storeMethod: PaymentMethod.apple,
      storePrice: '\$9.99',
      manualPrice: '5 000 ₸',
    )));
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    expect(find.text(l10n.paymentMethodAppStore), findsOneWidget);
    expect(find.text('\$9.99'), findsOneWidget);
    expect(find.text(l10n.paymentMethodManager), findsOneWidget);
  });

  testWidgets('без флага менеджера строки «Через менеджера» нет',
      (tester) async {
    await tester.pumpWidget(_app(const PaymentMethodSheet(
      storeMethod: PaymentMethod.google,
      storePrice: '4 990 ₸',
    )));
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    expect(find.text(l10n.paymentMethodGooglePlay), findsOneWidget);
    expect(find.text(l10n.paymentMethodManager), findsNothing);
  });

  testWidgets('выбор возвращает способ оплаты', (tester) async {
    PaymentMethod? picked;
    await tester.pumpWidget(_app(Builder(
      builder: (context) => TextButton(
        onPressed: () async => picked = await PaymentMethodSheet.show(context,
            storeMethod: PaymentMethod.apple,
            storePrice: '\$9.99',
            manualPrice: '5 000 ₸'),
        child: const Text('open'),
      ),
    )));
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.paymentMethodManager));
    await tester.pumpAndSettle();

    expect(picked, PaymentMethod.manual);
  });

  testWidgets('карточка без onBuy — без кнопки', (tester) async {
    await tester.pumpWidget(_app(SubscribeCard(subscribe: _plan)));
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    expect(find.text(l10n.buy), findsNothing);
  });

  testWidgets('карточка с onBuy — кнопка вызывает колбэк', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
        _app(SubscribeCard(subscribe: _plan, onBuy: () => tapped = true)));
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    await tester.tap(find.text(l10n.buy));
    expect(tapped, isTrue);
  });
}
