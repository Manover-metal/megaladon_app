part of 'order_screen_my_cubit.dart';

enum OrderScreenMyStatus { loading, error, success }

class OrderScreenMyState extends Equatable {
  const OrderScreenMyState(
      {this.status = OrderScreenMyStatus.success,
      this.orders = const [],
      this.ordersResponded = const [],
      this.error,
      this.params = const OrderIndexRequestParams(statuses: OrderStatus.values),
      this.stock = false,
      this.stockResponded = false});
  final OrderScreenMyStatus status;
  final List<OrderModel> orders;
  final List<OrderModel> ordersResponded;

  final ErrorModel? error;
  final OrderIndexRequestParams params;
  final bool stock;
  final bool stockResponded;

  // ordersResponded и stockResponded обязаны быть в props: без них Equatable
  // считает состояние неизменившимся, когда обновился только список откликов,
  // и BlocBuilder вкладки «как исполнитель» не перестраивается.
  @override
  List<Object?> get props => [
        status,
        orders,
        ordersResponded,
        error,
        params,
        stock,
        stockResponded,
      ];

  OrderScreenMyState copyWith({
    OrderScreenMyStatus? status,
    List<OrderModel>? orders,
    List<OrderModel>? ordersResponded,
    ErrorModel? error,
    OrderIndexRequestParams? params,
    bool? stock,
    bool? stockResponded,
  }) =>
      OrderScreenMyState(
          status: status ?? this.status,
          orders: orders ?? this.orders,
          ordersResponded: ordersResponded ?? this.ordersResponded,
          error: error,
          params: params ?? this.params,
          stock: stock ?? this.stock,
          stockResponded: stockResponded ?? this.stockResponded);
}
