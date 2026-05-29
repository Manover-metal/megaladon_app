part of 'order_screen_details_cubit.dart';

enum OrderScreenDetailsStateStatus {
  initial,
  loading,
  success,
  error,
  errorMessage,
  deleted
}

class OrderScreenDetailsState extends Equatable {
  const OrderScreenDetailsState(
      {this.status = OrderScreenDetailsStateStatus.initial,
      this.order,
      this.error,
      this.errorMessage});
  final OrderScreenDetailsStateStatus status;
  final OrderModel? order;
  final ErrorModel? error;
  final ErrorModel? errorMessage;

  @override
  List<Object?> get props => [status, order, error, errorMessage];

  OrderScreenDetailsState copyWith(
          {OrderScreenDetailsStateStatus? status,
          OrderModel? order,
          ErrorModel? error,
          ErrorModel? errorMessage}) =>
      OrderScreenDetailsState(
        status: status ?? this.status,
        order: order ?? this.order,
        error: error ?? this.error,
        errorMessage: errorMessage ?? errorMessage,
      );
}
