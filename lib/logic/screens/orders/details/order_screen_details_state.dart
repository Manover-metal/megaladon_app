part of 'order_screen_details_cubit.dart';

abstract class OrderScreenDetailsState extends Equatable {}

class OrderScreenDetailsInitial extends OrderScreenDetailsState {
  OrderScreenDetailsInitial();

  @override
  List<Object> get props => [];
}

class OrderScreenDetailsLoader extends OrderScreenDetailsState {
  OrderScreenDetailsLoader();

  @override
  List<Object> get props => [];
}

class OrderScreenDetailsError extends OrderScreenDetailsState {
  final ErrorModel error;
  OrderScreenDetailsError(this.error);

  @override
  List<Object> get props => [error];
}

class OrderScreenDetailsSuccess extends  OrderScreenDetailsState {
  final OrderModel order;

  OrderScreenDetailsSuccess({required this.order});

  @override
  List<Object?> get props => [order];

  OrderScreenDetailsSuccess copyWith({
    OrderModel? order
  }) {
    return OrderScreenDetailsSuccess(
        order: order ?? this.order
    );
  }
}
