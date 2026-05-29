part of 'subscribe_cubit.dart';

abstract class SubscribeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscribeInitial extends SubscribeState {}

class SubscribeLoading extends SubscribeState {}

class SubscribeSuccess extends SubscribeState {
  SubscribeSuccess(this.subscribe);
  final SubscribeModel subscribe;

  @override
  List<Object?> get props => [subscribe];
}

class SubscribeError extends SubscribeState {
  SubscribeError(this.error);
  final ErrorModel error;

  @override
  List<Object?> get props => [error];
}
