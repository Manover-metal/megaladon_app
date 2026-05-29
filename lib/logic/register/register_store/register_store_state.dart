part of 'register_store_bloc.dart';

abstract class RegisterStoreState extends Equatable {
  const RegisterStoreState();
}

class RegisterStoreInitial extends RegisterStoreState {
  @override
  List<Object> get props => [];
}

class RegisterStoreSuccess extends RegisterStoreState {
  const RegisterStoreSuccess(this.store);
  final StoreModel store;

  @override
  List<Object?> get props => [store];
}

class RegisterStoreLoading extends RegisterStoreState {
  @override
  List<Object> get props => [];
}

class RegisterStoreError extends RegisterStoreState {
  const RegisterStoreError(this.error);
  final ErrorModel error;

  @override
  List<Object> get props => [error];
}
