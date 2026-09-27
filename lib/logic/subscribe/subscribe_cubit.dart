import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/subscribe_repository.dart';

part 'subscribe_state.dart';

class SubscribeCubit extends Cubit<SubscribeState> {
  SubscribeCubit({SubscribeRepository? repository, TargetPlatform? platform})
      : _repository = repository ?? SubscribeRepository(),
        _platform = platform ?? defaultTargetPlatform,
        super(SubscribeInitial());

  final SubscribeRepository _repository;
  final TargetPlatform _platform;
  StreamSubscription<List<PurchaseDetails>>? _purchases;

  /// Зовётся при старте приложения: незавершённые транзакции прошлых сессий
  /// магазин присылает сразу, и без completePurchase iOS шлёт их снова, а
  /// Google через 3 дня возвращает деньги. В тестах не вызывается.
  void listenStore() {
    _purchases ??= InAppPurchase.instance.purchaseStream.listen(
      _onPurchases,
      onError: (Object _) => emit(SubscribeError(ErrorModel.nothing)),
    );
  }

  /// Заявка «через менеджера» и активация бесплатного тарифа.
  Future<void> requestManager(SubscribeModel plan) async {
    if (state is SubscribeLoading) return;
    emit(SubscribeLoading());

    try {
      await _repository.create(plan, PaymentMethod.manual, _platform);
      emit(SubscribeSuccess(plan));
    } on DioException catch (error) {
      emit(SubscribeError(ErrorModel.parseDio(error)));
    } catch (_) {
      emit(SubscribeError(ErrorModel.nothing));
    }
  }

  /// Покупка в магазине. Результат придёт в purchaseStream.
  Future<void> buyInStore(
      SubscribeModel plan, ProductDetails product, PaymentMethod method) async {
    if (state is SubscribeLoading) return;
    emit(SubscribeLoading());

    try {
      final uuid = await _repository.create(plan, method, _platform);
      // uuid → appAccountToken (iOS) / obfuscatedAccountId (Android): по нему
      // вебхук магазина найдёт заявку.
      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam:
            PurchaseParam(productDetails: product, applicationUserName: uuid),
      );
    } on DioException catch (error) {
      emit(SubscribeError(ErrorModel.parseDio(error)));
    } catch (_) {
      emit(SubscribeError(ErrorModel.nothing));
    }
  }

  Future<void> restore() async {
    await InAppPurchase.instance.restorePurchases();
    emit(SubscribeRestored());
  }

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        emit(SubscribePending());
      } else if (purchase.status == PurchaseStatus.error) {
        final message = purchase.error?.message;
        emit(SubscribeError(message == null || message.isEmpty
            ? ErrorModel.nothing
            : ErrorModel([message])));
      } else if (purchase.status == PurchaseStatus.canceled) {
        // Заявка остаётся CREATED — как брошенные заявки сейчас.
        emit(SubscribeInitial());
      }

      if (purchase.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  @override
  Future<void> close() {
    _purchases?.cancel();
    return super.close();
  }
}
