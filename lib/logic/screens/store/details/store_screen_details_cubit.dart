import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/store_repository.dart';

part 'store_screen_details_state.dart';

class StoreScreenDetailsCubit extends Cubit<StoreScreenDetailsState> {
  final StoreRepository _repository = StoreRepository();
  StoreScreenDetailsCubit() : super(StoreScreenDetailsInitial());

  Future fetch({required int id}) async {
    if(state is StoreScreenDetailsSuccess) {
      if((state as StoreScreenDetailsSuccess).store.id == id) return;
    }
    emit(StoreScreenDetailsLoader());
    return await _repository.info(id).then((value) {
      print(value);
      emit(StoreScreenDetailsSuccess(
          store: value
      ));
    }).catchError(( error) {
      if(error is DioError) {
        emit(StoreScreenDetailsError(ErrorModel.parseDio(error)));
      } else {
        emit(StoreScreenDetailsError(ErrorModel.nothing));
      }
    });
  }
}
