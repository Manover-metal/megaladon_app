part of 'register_store_bloc.dart';

abstract class RegisterStoreState extends Equatable {
  const RegisterStoreState();
}


class RegisterStoreInitial extends RegisterStoreState {
  @override
  List<Object> get props => [];
}

class RegisterStoreSuccess extends RegisterStoreState {
  @override
  List<Object?> get props => [];
}

class RegisterStoreLoading extends RegisterStoreState {
  @override
  List<Object> get props => [];
}

class RegisterStoreError extends RegisterStoreState {
  final ErrorModel error;

  const RegisterStoreError(this.error);

  @override
  List<Object> get props => [error];
}