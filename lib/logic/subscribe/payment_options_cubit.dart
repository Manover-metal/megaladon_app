import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/repositories/subscribe_repository.dart';

typedef ProductQuery = Future<Map<String, ProductDetails>> Function(
    Set<String> ids);

/// Какие из товаров покупатель получит с бесплатным пробным периодом.
typedef TrialQuery = Future<Set<String>> Function(
    Map<String, ProductDetails> products);

/// Цена, которую покупатель будет платить регулярно. У предложения Google
/// с пробным периодом ProductDetails.price — цена первой фазы («0 ₸»), а
/// регулярная — в последней фазе.
String recurringPrice(ProductDetails product) =>
    _lastPhase(product)?.formattedPrice ?? product.price;

double recurringRawPrice(ProductDetails product) {
  final phase = _lastPhase(product);
  return phase == null ? product.rawPrice : phase.priceAmountMicros / 1e6;
}

PricingPhaseWrapper? _lastPhase(ProductDetails product) {
  if (product is! GooglePlayProductDetails) return null;
  final index = product.subscriptionIndex;
  final offers = product.productDetails.subscriptionOfferDetails;
  if (index == null || offers == null) return null;
  return offers[index].pricingPhases.last;
}

/// Предложение начинается с бесплатной фазы. Google отдаёт только те
/// предложения, на которые у покупателя есть право, — значит, наличие такого
/// предложения и есть право на пробный период.
bool _startsFree(GooglePlayProductDetails product) {
  final index = product.subscriptionIndex;
  final offers = product.productDetails.subscriptionOfferDetails;
  if (index == null || offers == null) return false;
  return offers[index].pricingPhases.first.priceAmountMicros == 0;
}

class PaymentOptionsState extends Equatable {
  const PaymentOptionsState({
    this.manual = false,
    this.products = const {},
    this.storeFailed = false,
    this.trials = const {},
  });

  /// Показывать «Через менеджера» — флаг из админки для этой платформы.
  final bool manual;

  /// Товары магазина по product ID; нет товара — через магазин не купить.
  final Map<String, ProductDetails> products;

  /// Магазин не отдал хотя бы один товар, заведённый в тарифах.
  final bool storeFailed;

  /// product ID, которые покупатель получит с бесплатным пробным периодом.
  final Set<String> trials;

  /// Срок пробного периода для подписи на карточке; null — его нет или
  /// покупателю он уже не положен (магазин даёт его один раз).
  int? trialMonthsFor(SubscribeModel plan, TargetPlatform platform) {
    final id = plan.storeProductId(platform);
    return id != null && trials.contains(id) ? plan.trialMonths : null;
  }

  ProductDetails? productFor(SubscribeModel plan, TargetPlatform platform) {
    final id = plan.storeProductId(platform);
    return id == null ? null : products[id];
  }

  @override
  List<Object?> get props => [manual, products, storeFailed, trials];
}

/// Какие способы оплаты показать: флаг менеджера с бэка и товары магазина.
class PaymentOptionsCubit extends Cubit<PaymentOptionsState> {
  PaymentOptionsCubit({
    SubscribeRepository? repository,
    ProductQuery? queryProducts,
    TrialQuery? queryTrials,
    TargetPlatform? platform,
  })  : _repository = repository ?? SubscribeRepository(),
        _query = queryProducts ?? _queryStore,
        _queryTrials = queryTrials ?? _trialsInStore,
        _platform = platform ?? defaultTargetPlatform,
        super(const PaymentOptionsState());

  final SubscribeRepository _repository;
  final ProductQuery _query;
  final TrialQuery _queryTrials;
  final TargetPlatform _platform;

  Future<void> load(List<SubscribeModel> plans) async {
    final ids = plans
        .map((plan) => plan.storeProductId(_platform))
        .whereType<String>()
        .toSet();

    // Ошибка любого источника скрывает только его способ, а не весь экран.
    final manual =
        _repository.manualAvailable(_platform).catchError((Object _) => false);
    final products = ids.isEmpty
        ? Future.value(<String, ProductDetails>{})
        : _query(ids).catchError((Object _) => <String, ProductDetails>{});

    final found = await products;
    // Пробный период подписываем только у тарифов, где он заведён в админке.
    final withTrial = {
      for (final plan in plans)
        if (plan.trialMonths != null) plan.storeProductId(_platform)
    };
    final trials = await _queryTrials({
      for (final e in found.entries)
        if (withTrial.contains(e.key)) e.key: e.value
    }).catchError((Object _) => <String>{});
    final state = PaymentOptionsState(
      manual: await manual,
      products: found,
      storeFailed: !found.keys.toSet().containsAll(ids),
      trials: trials,
    );
    if (!isClosed) emit(state);
  }

  static Future<Map<String, ProductDetails>> _queryStore(
      Set<String> ids) async {
    final store = InAppPurchase.instance;
    if (!await store.isAvailable()) return {};

    final response = await store.queryProductDetails(ids);
    return pickProducts(response.productDetails);
  }

  /// По товару на product ID. На Android подписка даёт по ProductDetails на
  /// каждое предложение, на которое у покупателя есть право. Предложение с
  /// бесплатной фазой берём в первую очередь: его offerToken и уйдёт в
  /// покупку. Иначе — базовый план (offerId == null).
  @visibleForTesting
  static Map<String, ProductDetails> pickProducts(
      List<ProductDetails> details) {
    final products = <String, ProductDetails>{};
    for (final product in details) {
      final current = products[product.id];
      if (current == null || _better(product, current)) {
        products[product.id] = product;
      }
    }
    return products;
  }

  static bool _better(ProductDetails candidate, ProductDetails current) {
    if (candidate is! GooglePlayProductDetails ||
        current is! GooglePlayProductDetails) {
      return false;
    }
    if (_startsFree(candidate) != _startsFree(current)) {
      return _startsFree(candidate);
    }
    return _offerId(candidate) == null && _offerId(current) != null;
  }

  static String? _offerId(GooglePlayProductDetails product) {
    final index = product.subscriptionIndex;
    final offers = product.productDetails.subscriptionOfferDetails;
    return index == null || offers == null ? null : offers[index].offerId;
  }

  /// Android: выбранное предложение начинается с бесплатной фазы. iOS: Apple
  /// подтверждает право на вводное предложение (раз на Apple ID в группе
  /// подписок) и при покупке применяет его сама.
  static Future<Set<String>> _trialsInStore(
      Map<String, ProductDetails> products) async {
    final trials = <String>{};
    for (final entry in products.entries) {
      final product = entry.value;
      if (product is GooglePlayProductDetails) {
        if (_startsFree(product)) trials.add(entry.key);
      } else if (await SK2Product.isIntroductoryOfferEligible(entry.key)) {
        trials.add(entry.key);
      }
    }
    return trials;
  }
}
