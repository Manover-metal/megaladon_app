import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
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
      print(error);
      emit(AdvertScreenMainError());
    });
  }

  changeParams(AdvertIndexRequestParams params) {
    if(state is AdvertScreenMainSuccess) {
      params.startRow = 0;
      emit((state as AdvertScreenMainSuccess).copyWith(params: params));
    }
  }
}
