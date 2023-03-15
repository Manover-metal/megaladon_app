import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'advert_screen_my_state.dart';


class AdvertScreenMyCubit extends Cubit<AdvertScreenMyState> {
  final AdvertRepository _repository = AdvertRepository();
  AdvertScreenMyCubit() : super(const AdvertScreenMyState());

  Future fetch({AdvertIndexRequestParams? params}) async {
    if(state.status == AdverScreenMyMainStatus.loading
        && state.error == null
    ) return;

    AdvertIndexRequestParams mainParams = params ?? state.params;
    emit(state.copyWith(status: AdverScreenMyMainStatus.loading, error: null, advers: state.advers));

    return await _repository.indexMy(mainParams).then((value) {
      if(mainParams.startRow == 0) {
        emit(state.copyWith(
            advers: value,
            params: mainParams,
            status: AdverScreenMyMainStatus.success,
            stock: value.length < mainParams.rowsPerPage
        ));
      } else {
        emit(state.copyWith(
          status: AdverScreenMyMainStatus.success,
          advers: [...state.advers, ...value],
          params: mainParams,
          stock: value.length < mainParams.rowsPerPage
        ));
      }
    }).catchError(( error) {
      if(error is DioError) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }


  changeParams(AdvertIndexRequestParams params) {
    emit(state.copyWith(
        params: params.copyWith(startRow: 0)
    ));
  }
}