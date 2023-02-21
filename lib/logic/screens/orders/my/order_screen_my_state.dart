part of 'order_screen_my_cubit.dart';

abstract class OrderScreenMyState extends Equatable {
  final OrderIndexRequestParams params;

  OrderScreenMyState({required this.params});
}

class OrderScreenMyInitial extends OrderScreenMyState {
  OrderScreenMyInitial() : super(params: OrderIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class OrderScreenMyLoader extends OrderScreenMyState {
  OrderScreenMyLoader() : super(params: OrderIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class OrderScreenMyError extends OrderScreenMyState {
  OrderScreenMyError() : super(params: OrderIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class OrderScreenMySuccess extends  OrderScreenMyState {
  final List<OrderModel> orders;

  OrderScreenMySuccess({required this.orders, required params}): super(params: params);

  @override
  List<Object?> get props => [params, orders];

  OrderScreenMySuccess copyWith({
    OrderIndexRequestParams? params,
    List<OrderModel>? orders
  }) {
    return OrderScreenMySuccess(
        params: params ?? this.params,
        orders: orders ?? this.orders
    );
  }
}
