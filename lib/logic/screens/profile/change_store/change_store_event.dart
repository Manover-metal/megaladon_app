part of 'change_store_bloc.dart';

abstract class ChangeStoreEvent extends Equatable {
  const ChangeStoreEvent();
}

class ChangeStoreFetchEvent extends ChangeStoreEvent {
  const ChangeStoreFetchEvent({
    required this.params,
  });
  final ChangeStoreRequestParams params;

  @override
  List<Object?> get props => [params];
}
