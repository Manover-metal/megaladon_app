import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/repositories/subscribe_repository.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/subscribe/payment_options_cubit.dart';
import 'package:megaladon/presentation/widgets/card/subscribe_card.dart';

class _Repo extends SubscribeRepository {
  @override
  Future<bool> manualAvailable(TargetPlatform platform) async => false;
}

PricingPhaseWrapper _phase(int micros, String formatted, String period) =>
    PricingPhaseWrapper(
      billingCycleCount: 1,
      billingPeriod: period,
      formattedPrice: formatted,
      priceAmountMicros: micros,
      priceCurrencyCode: 'KZT',
      recurrenceMode: RecurrenceMode.infiniteRecurring,
    );

const _basePlan = SubscriptionOfferDetailsWrapper(
  basePlanId: 'monthly',
  offerTags: [],
  offerIdToken: 'token-base',
  pricingPhases: [
    PricingPhaseWrapper(
      billingCycleCount: 0,
      billingPeriod: 'P1M',
      formattedPrice: '5 000 ₸',
      priceAmountMicros: 5000000000,
      priceCurrencyCode: 'KZT',
      recurrenceMode: RecurrenceMode.infiniteRecurring,
    ),
  ],
);

/// Как отдаёт Play Billing: по ProductDetails на каждое доступное предложение.
List<GooglePlayProductDetails> _android({required bool trialOffered}) =>
    GooglePlayProductDetails.fromProductDetails(ProductDetailsWrapper(
      description: '',
      name: 'Исполнитель, 1 мес.',
      productId: 'executor_1m',
      productType: ProductType.subs,
      title: 'Исполнитель',
      subscriptionOfferDetails: [
        // Базовый план первым — раньше его и брали, теряя пробный период.
        _basePlan,
        if (trialOffered)
          SubscriptionOfferDetailsWrapper(
            basePlanId: 'monthly',
            offerId: 'trial-3m',
            offerTags: const ['free-trial'],
            offerIdToken: 'token-trial',
            pricingPhases: [
              _phase(0, 'Бесплатно', 'P3M'),
              _phase(5000000000, '5 000 ₸', 'P1M'),
            ],
          ),
      ],
    ));

SubscribeModel _plan({int? trial}) => SubscribeModel(
      id: 1,
      type: SubscribeType.executor,
      duration: 1,
      price: 5000,
      googleProductId: 'executor_1m',
      appleProductId: 'executor_1m',
      trialMonths: trial,
    );

void main() {
  group('Android: выбор предложения', () {
    test('предложение с бесплатной фазой важнее базового плана', () {
      final picked = PaymentOptionsCubit.pickProducts(
          _android(trialOffered: true))['executor_1m']!
          as GooglePlayProductDetails;

      expect(picked.offerToken, 'token-trial');
      // Регулярная цена, а не «Бесплатно» первой фазы.
      expect(recurringPrice(picked), '5 000 ₸');
      expect(recurringRawPrice(picked), 5000);
    });

    test('пробного нет (уже пользовался) — базовый план', () {
      final picked = PaymentOptionsCubit.pickProducts(
          _android(trialOffered: false))['executor_1m']!
          as GooglePlayProductDetails;
      expect(picked.offerToken, 'token-base');
      expect(recurringPrice(picked), '5 000 ₸');
    });
  });

  group('право на пробный период', () {
    Future<PaymentOptionsState> load(
        {required bool trialOffered, int? trialMonths}) async {
      final cubit = PaymentOptionsCubit(
        repository: _Repo(),
        platform: TargetPlatform.android,
        queryProducts: (_) async =>
            PaymentOptionsCubit.pickProducts(_android(trialOffered: trialOffered)),
      );
      await cubit.load([_plan(trial: trialMonths)]);
      return cubit.state;
    }

    test('Google предложил бесплатную фазу и тариф с пробным — 3 мес.', () async {
      final state = await load(trialOffered: true, trialMonths: 3);
      expect(state.trialMonthsFor(_plan(trial: 3), TargetPlatform.android), 3);
    });

    test('Google не предложил — пробного не показываем', () async {
      final state = await load(trialOffered: false, trialMonths: 3);
      expect(
          state.trialMonthsFor(_plan(trial: 3), TargetPlatform.android), isNull);
    });

    test('в админке пробный не заведён — не показываем, даже если есть в Google',
        () async {
      final state = await load(trialOffered: true);
      expect(state.trialMonthsFor(_plan(), TargetPlatform.android), isNull);
    });

    test('iOS: право спрашиваем у Apple только для тарифов с пробным', () async {
      final asked = <String>[];
      final cubit = PaymentOptionsCubit(
        repository: _Repo(),
        platform: TargetPlatform.iOS,
        queryProducts: (ids) async => {
          for (final id in ids)
            id: ProductDetails(
                id: id,
                title: id,
                description: '',
                price: '5 000 ₸',
                rawPrice: 5000,
                currencyCode: 'KZT'),
        },
        queryTrials: (products) async {
          asked.addAll(products.keys);
          return products.keys.toSet();
        },
      );
      await cubit.load([
        _plan(trial: 3),
        SubscribeModel(
            id: 2,
            type: SubscribeType.executor,
            duration: 12,
            price: 50000,
            appleProductId: 'executor_12m'),
      ]);

      expect(asked, ['executor_1m']);
      expect(cubit.state.trialMonthsFor(_plan(trial: 3), TargetPlatform.iOS), 3);
    });
  });

  group('карточка тарифа', () {
    Future<void> pump(WidgetTester tester, {int? trial}) =>
        tester.pumpWidget(MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SubscribeCard(
              subscribe: _plan(trial: 3),
              product: PaymentOptionsCubit.pickProducts(
                  _android(trialOffered: true))['executor_1m'],
              trialMonths: trial,
              onBuy: () {},
            ),
          ),
        ));

    testWidgets('с пробным: срок, цена после него и «Попробовать бесплатно»',
        (tester) async {
      await pump(tester, trial: 3);
      final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

      expect(find.text('3 месяца бесплатно'), findsOneWidget);
      expect(find.text('5 000 ₸'), findsOneWidget);
      expect(find.textContaining('Первые 3 месяца бесплатно, затем 5 000 ₸'),
          findsOneWidget);
      expect(find.text(l10n.subscriptionTryFree), findsOneWidget);
      expect(find.text('Бесплатно'), findsNothing);
    });

    testWidgets('без права на пробный — обычная покупка', (tester) async {
      await pump(tester);
      final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

      expect(find.textContaining('бесплатно'), findsNothing);
      expect(find.text(l10n.buy), findsOneWidget);
    });
  });
}
