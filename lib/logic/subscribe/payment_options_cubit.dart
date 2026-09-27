import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/repositories/subscribe_repository.dart';

typedef ProductQuery = Future<Map<String, ProductDetails>> Function(
    Set<String> ids);

class PaymentOptionsState extends Equatable {
  const PaymentOptionsState({this.manual = false, this.products = const {}});

  /// Показывать «Через менеджера» — флаг из админки для этой платформы.
  final bool manual;

  /// Товары магазина по product ID; нет товара — через магазин не купить.
  final Map<String, ProductDetails> products;

  ProductDetails? productFor(SubscribeModel plan, TargetPlatform platform) {
    final id = plan.storeProductId(platform);
    return id == null ? null : products[id];
  }

  @override
  List<Object?> get props => [manual, products];
}

/// Какие способы оплаты показать: флаг менеджера с бэка и товары магазина.
class PaymentOptionsCubit extends Cubit<PaymentOptionsState> {
  PaymentOptionsCubit({
    SubscribeRepository? repository,
    ProductQuery? queryProducts,
    TargetPlatform? platform,
  })  : _repository = repository ?? SubscribeRepository(),
        _query = queryProducts ?? _queryStore,
        _platform = platform ?? defaultTargetPlatform,
        super(const PaymentOptionsState());

  final SubscribeRepository _repository;
  final ProductQuery _query;
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

    final state =
        PaymentOptionsState(manual: await manual, products: await products);
    if (!isClosed) emit(state);
  }

  static Future<Map<String, ProductDetails>> _queryStore(
      Set<String> ids) async {
    final store = InAppPurchase.instance;
    if (!await store.isAvailable()) return {};

    final response = await store.queryProductDetails(ids);
    // ponytail: на Android подписка с несколькими предложениями даёт по
    // ProductDetails на каждое — берём первое. В Play Console держать один
    // базовый план без предложений; иначе выбирать предложение явно.
    final products = <String, ProductDetails>{};
    for (final product in response.productDetails) {
      products.putIfAbsent(product.id, () => product);
    }
    return products;
  }
}
