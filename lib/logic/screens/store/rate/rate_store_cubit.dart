import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/store_repository.dart';

part 'rate_store_state.dart';

class RateStoreCubit extends Cubit<RateStoreState> {
  RateStoreCubit() : super(RateStoreInitial());

  final StoreRepository _repository = StoreRepository();

  Future<void> rate({required int storeId, required int value}) async {
    if (state is RateStoreLoading) return;

    emit(RateStoreLoading());

    await _repository.rate(storeId, value).then((_) {
      emit(RateStoreSuccess());
    }).catchError((Object error) {
      if (error is DioException) {
        emit(RateStoreError(ErrorModel.parseDio(error)));
      } else {
        emit(RateStoreError(ErrorModel.nothing));
      }
    });
  }
}
