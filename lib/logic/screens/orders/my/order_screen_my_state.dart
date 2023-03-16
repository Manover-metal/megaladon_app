part of 'order_screen_my_cubit.dart';

enum OrderScreenMyStatus {
  loading,
  error,
  success
}

class OrderScreenMyState extends Equatable {
  final OrderScreenMyStatus status;
  final List<OrderModel> orders;
  final ErrorModel? error;
  final OrderIndexRequestParams params;
  final bool stock;

  const OrderScreenMyState({
    this.status = OrderScreenMyStatus.success,
    this.orders = const [],
    this.error,
    this.params =  const OrderIndexRequestParams(),
    this.stock = false
  });

  @override
  List<Object?> get props => [status, orders, error, params, stock];

  OrderScreenMyState copyWith({
    OrderScreenMyStatus? status,
    List<OrderModel>? orders,
    ErrorModel? error,
    OrderIndexRequestParams? params,
    bool? stock
  }) {
    return OrderScreenMyState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error,
      params: params ?? this.params,
      stock: stock ?? this.stock
    );
  }

}