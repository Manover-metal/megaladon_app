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
    id: 1, type: SubscribeType.executor, duration: 6, price: 25000);

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('ru'));
  });

  testWidgets('крупная цена магазина, кнопка магазина и заявка менеджеру',
      (tester) async {
    await tester.pumpWidget(_app(PaymentMethodSheet(
      plan: _plan,
      storeMethod: PaymentMethod.apple,
      storePrice: '24 990 ₸',
      manualPrice: '25 000 ₸',
    )));

    expect(find.text(l10n.months_count(6)), findsOneWidget);
    expect(find.text('24 990 ₸'), findsOneWidget);
    expect(find.text(l10n.paymentPayIn(l10n.paymentMethodAppStore)),
        findsOneWidget);
    expect(find.text(l10n.paymentOr), findsOneWidget);
    expect(find.text(l10n.paymentManagerRequest('25 000 ₸')), findsOneWidget);
    expect(find.text(l10n.paymentCancelHintIos), findsOneWidget);
  });

  testWidgets('перечисляет, что даёт подписка исполнителя', (tester) async {
    await tester.pumpWidget(_app(PaymentMethodSheet(
      plan: _plan,
      storeMethod: PaymentMethod.apple,
      storePrice: '24 990 ₸',
    )));

    expect(find.text(l10n.subscriptionExecutorBenefit1Title), findsOneWidget);
    expect(find.text(l10n.subscriptionExecutorBenefit2Title), findsOneWidget);
  });

  testWidgets('без флага менеджера нет ни разделителя, ни заявки',
      (tester) async {
    await tester.pumpWidget(_app(PaymentMethodSheet(
      plan: _plan,
      storeMethod: PaymentMethod.google,
      storePrice: '24 990 ₸',
    )));

    expect(find.text(l10n.paymentPayIn(l10n.paymentMethodGooglePlay)),
        findsOneWidget);
    expect(find.text(l10n.paymentCancelHintAndroid), findsOneWidget);
    expect(find.text(l10n.paymentOr), findsNothing);
    expect(find.textContaining(l10n.paymentManagerRequest('')), findsNothing);
  });

  testWidgets('без магазина крупная цена — менеджерская, без разделителя',
      (tester) async {
    await tester.pumpWidget(_app(PaymentMethodSheet(
      plan: _plan,
      manualPrice: '25 000 ₸',
    )));

    expect(find.text('25 000 ₸'), findsOneWidget);
    expect(find.text(l10n.paymentManagerRequest('25 000 ₸')), findsOneWidget);
    expect(find.text(l10n.paymentOr), findsNothing);
  });

  testWidgets('кнопки возвращают способ оплаты', (tester) async {
    Future<PaymentMethod?> pick(String buttonText) async {
      PaymentMethod? picked;
      await tester.pumpWidget(_app(Builder(
        builder: (context) => TextButton(
          onPressed: () async => picked = await PaymentMethodSheet.show(
            context,
            plan: _plan,
            storeMethod: PaymentMethod.apple,
            storePrice: '24 990 ₸',
            manualPrice: '25 000 ₸',
          ),
          child: const Text('open'),
        ),
      )));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();
      return picked;
    }

    expect(await pick(l10n.paymentManagerRequest('25 000 ₸')),
        PaymentMethod.manual);
    expect(await pick(l10n.paymentPayIn(l10n.paymentMethodAppStore)),
        PaymentMethod.apple);
  });

  testWidgets('карточка без onBuy — без кнопки', (tester) async {
    await tester.pumpWidget(_app(SubscribeCard(subscribe: _plan)));

    expect(find.text(l10n.buy), findsNothing);
  });

  testWidgets('карточка с onBuy — кнопка вызывает колбэк', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
        _app(SubscribeCard(subscribe: _plan, onBuy: () => tapped = true)));

    await tester.tap(find.text(l10n.buy));
    expect(tapped, isTrue);
  });
}
