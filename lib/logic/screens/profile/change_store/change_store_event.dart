part of 'change_store_bloc.dart';

abstract class ChangeStoreEvent extends Equatable {
  const ChangeStoreEvent();
}

class ChangeStoreFetchEvent extends ChangeStoreEvent {
  final ChangeStoreRequestParams params;

  const ChangeStoreFetchEvent({
    required this.params,
  });

  @override
  List<Object?> get props => [params];

}