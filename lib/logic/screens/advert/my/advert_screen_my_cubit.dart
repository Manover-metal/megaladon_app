import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/advert_index_request_params.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'advert_screen_my_state.dart';

class AdvertScreenMyCubit extends Cubit<AdvertScreenMyState> {
  final AdvertRepository _repository = AdvertRepository();
  AdvertScreenMyCubit() : super(AdvertScreenMyInitial());

  Future fetch({AdvertIndexRequestParams? params}) async {
    AdvertIndexRequestParams mainParams = params ?? state.params;
    emit(AdvertScreenMyLoader());
    await _repository.indexMy(mainParams).then((value) {
      if(mainParams.startRow == 0) {
        emit(AdvertScreenMySuccess(adverts: value, params: mainParams));
      } else {
        emit(AdvertScreenMySuccess(
          adverts: [...(state as AdvertScreenMySuccess).adverts, value],
          params: mainParams
        ));
      }
    }).catchError((error) {
      if(error is DioError) {
        emit(AdvertScreenMyError(ErrorModel.parseDio(error)));
      } else {
        emit(AdvertScreenMyError(ErrorModel.nothing));
      }
    });
  }

  changeParams(AdvertIndexRequestParams params) {
    if(state is AdvertScreenMySuccess) {
      params.startRow = 0;
      emit((state as AdvertScreenMySuccess).copyWith(params: params));
    }
  }
}
