import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/repositories/offer_repository.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_details_state.dart';

class OrderScreenDetailsCubit extends Cubit<OrderScreenDetailsState> {
  OrderScreenDetailsCubit() : super(const OrderScreenDetailsState());
  final OrderRepository _repository = OrderRepository();
  final OfferRepository _offerRepository = OfferRepository();

  Future fetch({required int id}) async {
    emit(state.copyWith(status: OrderScreenDetailsStateStatus.loading));

    return await _fetch(id);
  }

  /// Перечитать заказ без экрана загрузки — например, после отправки
  /// отклика: кнопка должна смениться на «Посмотреть предложение» сразу.
  Future<void> refresh({required int id}) async => _fetch(id);

  /// Идёт «Завершить» или «Назначить» — повторное нажатие не шлёт второй
  /// запрос и не открывает следующий экран дважды.
  bool _actionInFlight = false;

  /// Завершает заказ. Успех — статус [OrderScreenDetailsStateStatus.completed],
  /// по нему listener экрана заказа ведёт к отзыву. Раньше экран сам ждал
  /// результата и переходил — и при ошибке тоже, её глотали.
  Future<void> complete() async {
    if (_actionInFlight ||
        state.status != OrderScreenDetailsStateStatus.success) {
      return;
    }
    _actionInFlight = true;
    final id = state.order!.id;
    try {
      await _repository.complete(id);
      await _fetch(id);
      _emitIfFetched(OrderScreenDetailsStateStatus.completed);
    } catch (error) {
      _emitActionError(error);
    } finally {
      _actionInFlight = false;
    }
  }

  /// Назначает исполнителем автора отклика. Успех — статус
  /// [OrderScreenDetailsStateStatus.offerAccepted], по нему listener экрана
  /// отклика уходит к заказу.
  Future<void> acceptOffer({required int orderId, required int offerId}) async {
    if (_actionInFlight) return;
    _actionInFlight = true;
    try {
      await _offerRepository.accept(orderId, offerId);
      await _fetch(orderId);
      _emitIfFetched(OrderScreenDetailsStateStatus.offerAccepted);
    } catch (error) {
      _emitActionError(error);
    } finally {
      _actionInFlight = false;
    }
  }

  /// Итог действия выставляем, только если заказ перечитался: _fetch свои
  /// ошибки не бросает, а выставляет статус error.
  void _emitIfFetched(OrderScreenDetailsStateStatus status) {
    if (state.status == OrderScreenDetailsStateStatus.success) {
      emit(state.copyWith(status: status));
    }
  }

  void _emitActionError(Object error) {
    emit(state.copyWith(
        status: OrderScreenDetailsStateStatus.errorMessage,
        errorMessage: error is DioException
            ? ErrorModel.parseDio(error)
            : ErrorModel.nothing));
  }

  // Состояние собираем целиком, а не через copyWith: иначе myOfferId от
  // прошлого открытого заказа (кубит один на приложение) пережил бы смену
  // заказа — copyWith не умеет сбросить поле в null.
  Future _fetch(int id) async => await _repository.details(id).then((value) {
        emit(OrderScreenDetailsState(
          status: OrderScreenDetailsStateStatus.success,
          order: value.order,
          myOfferId: value.myOfferId,
        ));
      }).catchError((error, stackTrace) {
        print(error);
        print(stackTrace);
        if (error is DioException) {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.error,
              error: ErrorModel.parseDio(error)));
        } else {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.error,
              error: ErrorModel.nothing));
        }
      });
}
