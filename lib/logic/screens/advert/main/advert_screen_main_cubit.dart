import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'advert_screen_main_state.dart';

class AdvertScreenMainCubit extends Cubit<AdvertScreenMainState> {
  AdvertScreenMainCubit() : super(const AdvertScreenMainState());
  final AdvertRepository _repository = AdvertRepository();

  Future fetchAdvert({AdvertIndexRequestParams? params}) async {
    if (state.status == AdverScreenMainStatus.loading && state.error == null)
      return;

    var mainParams = params ?? state.params;
    emit(state.copyWith(
      status: AdverScreenMainStatus.loading,
      error: null,
      adverts: state.adverts,
      params: mainParams,
    ));

    return await _repository.index(mainParams).then((value) {
      if (mainParams.startRow == 0) {
        emit(state.copyWith(
            adverts: value,
            params: mainParams,
            status: AdverScreenMainStatus.success,
            stock: value.length < mainParams.rowsPerPage));
      } else {
        emit(state.copyWith(
            status: AdverScreenMainStatus.success,
            adverts: [...state.adverts, ...value],
            params: mainParams,
            stock: value.length < mainParams.rowsPerPage));
      }
    }).catchError((error) {
      if (error is DioException) {
        emit(state.copyWith(
            status: AdverScreenMainStatus.error,
            error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(
            status: AdverScreenMainStatus.error, error: ErrorModel.nothing));
      }
    });
  }

  Future fetchService({AdvertIndexRequestParams? params}) async {
    if (state.status == AdverScreenMainStatus.loading && state.error == null)
      return;

    var mainParams = params ?? state.params;
    emit(state.copyWith(
      status: AdverScreenMainStatus.loading,
      error: null,
      services: state.services,
      params: mainParams,
    ));

    return await _repository
        .index(mainParams, AdvertType.service)
        .then((value) {
      if (mainParams.startRow == 0) {
        emit(state.copyWith(
            services: value,
            params: mainParams,
            status: AdverScreenMainStatus.success,
            stock: value.length < mainParams.rowsPerPage));
      } else {
        emit(state.copyWith(
            status: AdverScreenMainStatus.success,
            services: [...state.services, ...value],
            params: mainParams,
            stock: value.length < mainParams.rowsPerPage));
      }
    }).catchError((error) {
      if (error is DioException) {
        emit(state.copyWith(
            status: AdverScreenMainStatus.error,
            error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(
            status: AdverScreenMainStatus.error, error: ErrorModel.nothing));
      }
    });
  }

  void changeParams(AdvertIndexRequestParams params) {
    emit(state.copyWith(params: params.copyWith(startRow: 0)));
  }
}
