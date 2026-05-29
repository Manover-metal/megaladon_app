part of 'order_delete_cubit.dart';

abstract class OrderDeleteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderDeleteInitial extends OrderDeleteState {}

class OrderDeleteLoading extends OrderDeleteState {}

class OrderDeleteSuccess extends OrderDeleteState {}

class OrderDeleteError extends OrderDeleteState {
  OrderDeleteError(this.error);
  final ErrorModel error;

  @override
  List<Object?> get props => [error];
}
