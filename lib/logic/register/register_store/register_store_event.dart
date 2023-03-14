part of 'register_store_bloc.dart';

abstract class RegisterStoreEvent extends Equatable {
  const RegisterStoreEvent();
}

class RegisterStoreFetchEvent extends RegisterStoreEvent {
  final RegisterStoreRequestParams params;

  const RegisterStoreFetchEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];

}