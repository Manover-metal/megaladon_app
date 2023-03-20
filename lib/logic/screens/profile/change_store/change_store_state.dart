part of 'change_store_bloc.dart';

abstract class ChangeStoreState extends Equatable {
  const ChangeStoreState();
}


class ChangeStoreInitial extends ChangeStoreState {
  @override
  List<Object> get props => [];
}

class ChangeStoreSuccess extends ChangeStoreState {

  const ChangeStoreSuccess();

  @override
  List<Object?> get props => [];
}

class ChangeStoreLoading extends ChangeStoreState {
  @override
  List<Object> get props => [];
}

class ChangeStoreError extends ChangeStoreState {
  final ErrorModel error;

  const ChangeStoreError(this.error);

  @override
  List<Object> get props => [error];
}