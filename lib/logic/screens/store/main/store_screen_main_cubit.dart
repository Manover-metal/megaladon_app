import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/store_repository.dart';

part 'store_screen_main_state.dart';

class StoreScreenMainCubit extends Cubit<StoreScreenMainState> {
  final StoreRepository _repository = StoreRepository();
  StoreScreenMainCubit() : super(StoreScreenMainInitial());

  Future fetch({StoreIndexRequestParams? params}) async {
    StoreIndexRequestParams mainParams = params ?? state.params;

    emit(StoreScreenMainLoader());
    return await _repository.index(mainParams).then((value) {
      print(value);
      if(mainParams.startRow == 0) {
        emit(StoreScreenMainSuccess(stores: value, params: mainParams));
      } else {
        emit(StoreScreenMainSuccess(
          stores: [...(state as StoreScreenMainSuccess).stores, value],
          params: mainParams
        ));
      }
    }).catchError((error) {
      print(error);
      emit(StoreScreenMainError());
    });
  }

  changeParams(StoreIndexRequestParams params) {
    if(state is StoreScreenMainSuccess) {
      params.startRow = 0;
      emit((state as StoreScreenMainSuccess).copyWith(params: params));
    }
  }
}
