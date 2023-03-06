part of 'order_screen_main_cubit.dart';

abstract class OrderScreenMainState extends Equatable {
  final OrderIndexRequestParams params;

  OrderScreenMainState({required this.params});
}

class OrderScreenMainInitial extends OrderScreenMainState {
  OrderScreenMainInitial() : super(params: OrderIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class OrderScreenMainLoader extends OrderScreenMainState {
  OrderScreenMainLoader() : super(params: OrderIndexRequestParams());

  @override
  List<Object> get props => [params];
}

class OrderScreenMainError extends OrderScreenMainState {
  final ErrorModel error;
  OrderScreenMainError(this.error) : super(params: OrderIndexRequestParams());

  @override
  List<Object> get props => [error, params];
}

class OrderScreenMainSuccess extends  OrderScreenMainState {
  final List<OrderModel> orders;

  OrderScreenMainSuccess({required this.orders, required params}): super(params: params);

  @override
  List<Object?> get props => [params, orders];

  OrderScreenMainSuccess copyWith({
    OrderIndexRequestParams? params,
    List<OrderModel>? orders
  }) {
    return OrderScreenMainSuccess(
        params: params ?? this.params,
        orders: orders ?? this.orders
    );
  }
}
