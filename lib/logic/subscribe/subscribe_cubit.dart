import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/subscribe_repository.dart';

part 'subscribe_state.dart';

class SubscribeCubit extends Cubit<SubscribeState> {
  SubscribeCubit() : super(SubscribeInitial());

  Future<void> buy(SubscribeModel subscribe) async {
    if (state is SubscribeLoading) return;

    emit(SubscribeLoading());

    final future = subscribe.type == SubscribeType.executor
        ? SubscribeRepository.createForExecutor(subscribe.id)
        : SubscribeRepository.createForStore(subscribe.id);

    await future.then((_) {
      emit(SubscribeSuccess(subscribe));
    }).catchError((Object error) {
      if (error is DioException) {
        emit(SubscribeError(ErrorModel.parseDio(error)));
      } else {
        emit(SubscribeError(ErrorModel.nothing));
      }
    });
  }
}
