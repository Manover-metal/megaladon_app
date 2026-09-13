part of 'order_screen_details_cubit.dart';

enum OrderScreenDetailsStateStatus {
  initial,
  loading,
  success,
  error,
  errorMessage,
  deleted,

  /// Заказ завершён (после «Завершить работу»): экран заказа по нему ведёт
  /// к отзыву. Заказ в state уже перечитан.
  completed,

  /// Исполнитель назначен (после «Назначить» на отклике): экран отклика по
  /// нему уходит к заказу. Заказ в state уже перечитан.
  offerAccepted,
}

class OrderScreenDetailsState extends Equatable {
  const OrderScreenDetailsState(
      {this.status = OrderScreenDetailsStateStatus.initial,
      this.order,
      this.myOfferId,
      this.error,
      this.errorMessage});
  final OrderScreenDetailsStateStatus status;
  final OrderModel? order;

  /// Отклик текущего пользователя на этот заказ; null — не откликался.
  final int? myOfferId;
  final ErrorModel? error;
  final ErrorModel? errorMessage;

  @override
  List<Object?> get props => [status, order, myOfferId, error, errorMessage];

  OrderScreenDetailsState copyWith(
          {OrderScreenDetailsStateStatus? status,
          OrderModel? order,
          int? myOfferId,
          ErrorModel? error,
          ErrorModel? errorMessage}) =>
      OrderScreenDetailsState(
        status: status ?? this.status,
        order: order ?? this.order,
        myOfferId: myOfferId ?? this.myOfferId,
        error: error ?? this.error,
        errorMessage: errorMessage ?? errorMessage,
      );
}
