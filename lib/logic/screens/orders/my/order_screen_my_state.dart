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

  const OrderScreenMyState({
    this.status = OrderScreenMyStatus.success,
    this.orders = const [],
    this.error,
    this.params =  const OrderIndexRequestParams()
  });

  @override
  List<Object?> get props => [status, orders, error, params];

  OrderScreenMyState copyWith({
    OrderScreenMyStatus? status,
    List<OrderModel>? orders,
    ErrorModel? error,
    OrderIndexRequestParams? params
  }) {
    return OrderScreenMyState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error,
      params: params ?? this.params
    );
  }

}



// abstract class OrderScreenMyState extends Equatable {
//   final OrderIndexRequestParams params;

//   OrderScreenMyState({required this.params});

//   get orders => null;

//   OrderScreenMyState copyWith({required OrderScreenMainStatus status, required List orders, required OrderIndexRequestParams params, required error}) {}
// }

// class OrderScreenMyInitial extends OrderScreenMyState {
//   OrderScreenMyInitial() : super(params: OrderIndexRequestParams());

//   @override
//   List<Object> get props => [params];
// }

// class OrderScreenMyLoader extends OrderScreenMyState {
//   OrderScreenMyLoader() : super(params: OrderIndexRequestParams());

//   @override
//   List<Object> get props => [params];
// }

// class OrderScreenMyError extends OrderScreenMyState {
//   final ErrorModel error;
//   OrderScreenMyError(this.error) : super(params: OrderIndexRequestParams());

//   @override
//   List<Object> get props => [error, params];
// }

// class OrderScreenMySuccess extends  OrderScreenMyState {
//   final List<OrderModel> orders;

//   OrderScreenMySuccess({required this.orders, required params}): super(params: params);

//   @override
//   List<Object?> get props => [params, orders];

//   OrderScreenMySuccess copyWith({
//     OrderIndexRequestParams? params,
//     List<OrderModel>? orders
//   }) {
//     return OrderScreenMySuccess(
//         params: params ?? this.params,
//         orders: orders ?? this.orders
//     );
//   }
// }
