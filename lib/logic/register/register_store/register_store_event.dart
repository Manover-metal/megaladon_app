part of 'register_store_bloc.dart';

abstract class RegisterStoreEvent extends Equatable {
  const RegisterStoreEvent();
}

class RegisterStoreFetchEvent extends RegisterStoreEvent {
  const RegisterStoreFetchEvent({
    required this.params,
  });
  final RegisterStoreRequestParams params;

  @override
  List<Object?> get props => [params];
}
