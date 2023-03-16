part of 'order_screen_main_cubit.dart';

enum OrderScreenMainStatus {
  loading,
  error,
  success
}

class OrderScreenMainState extends Equatable {
  final OrderScreenMainStatus status;
  final List<OrderModel> orders;
  final ErrorModel? error;
  final OrderIndexRequestParams params;
  final bool stock;

  const OrderScreenMainState({
    this.status = OrderScreenMainStatus.success,
    this.orders = const [],
    this.error,
    this.params =  const OrderIndexRequestParams(),
    this.stock = false,
  });

  @override
  List<Object?> get props => [status, orders, error, params, stock];

  OrderScreenMainState copyWith({
    OrderScreenMainStatus? status,
    List<OrderModel>? orders,
    ErrorModel? error,
    OrderIndexRequestParams? params,
    bool? stock,
  }) {
    return OrderScreenMainState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error,
      params: params ?? this.params,
      stock: stock ?? this.stock
    );
  }

}