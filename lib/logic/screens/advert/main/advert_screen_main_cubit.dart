import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/advert_index_request_params.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'advert_screen_main_state.dart';

class AdvertScreenMainCubit extends Cubit<AdvertScreenMainState> {
  final AdvertRepository _repository = AdvertRepository();
  AdvertScreenMainCubit() : super(AdvertScreenMainInitial());

  Future fetch({AdvertIndexRequestParams? params}) async {
    AdvertIndexRequestParams mainParams = params ?? state.params;

    emit(AdvertScreenMainLoader());
    return await _repository.index(mainParams).then((value) {
      print(value);
      if(mainParams.startRow == 0) {
        emit(AdvertScreenMainSuccess(adverts: value, params: mainParams));
      } else {
        emit(AdvertScreenMainSuccess(
          adverts: [...(state as AdvertScreenMainSuccess).adverts, value],
          params: mainParams
        ));
      }
    }).catchError((error) {
      if(error is DioError) {
        emit(AdvertScreenMainError(ErrorModel.parseDio(error)));
      } else {
        emit(AdvertScreenMainError(ErrorModel.nothing));
      }
    });
  }

  changeParams(AdvertIndexRequestParams params) {
    if(state is AdvertScreenMainSuccess) {
      params.startRow = 0;
      emit((state as AdvertScreenMainSuccess).copyWith(params: params));
    }
  }
}
