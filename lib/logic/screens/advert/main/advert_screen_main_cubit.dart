import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'advert_screen_main_state.dart';

class AdvertScreenMainCubit extends Cubit<AdvertScreenMainState> {
  final AdvertRepository _repository = AdvertRepository();
  AdvertScreenMainCubit() : super(AdvertScreenMainInitial());

  Future fetch() async {
    emit(AdvertScreenMainLoader());
    await _repository.index(state.params).then((value) {
      if(state is AdvertScreenMainSuccess) {
        if(state.params.startRow == 0) {
          emit(AdvertScreenMainSuccess(adverts: value, params: state.params));
        } else {
          emit(AdvertScreenMainSuccess(
            adverts: [...(state as AdvertScreenMainSuccess).adverts, value],
            params: state.params
          ));
        }
      } else {
        emit(AdvertScreenMainSuccess(adverts: value, params: state.params));
      }
    }).catchError((Error error) {
      print(error.stackTrace);
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
