import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';

part 'advert_screen_details_state.dart';

class AdvertScreenDetailsCubit extends Cubit<AdvertScreenDetailsState> {
  AdvertScreenDetailsCubit() : super(AdvertScreenDetailsInitial());
  final AdvertRepository _repository = AdvertRepository();

  Future fetch({required int id}) async {
    if (state is AdvertScreenDetailsSuccess) {
      if ((state as AdvertScreenDetailsSuccess).advert.id == id) return;
    }
    emit(AdvertScreenDetailsLoader());
    return await _repository.info(id).then((value) {
      emit(AdvertScreenDetailsSuccess(advert: value));
    }).catchError((error, stackTrace) {
      print(error);
      print(stackTrace);
      if (error is DioException) {
        emit(AdvertScreenDetailsError(ErrorModel.parseDio(error)));
      } else {
        emit(AdvertScreenDetailsError(ErrorModel.nothing));
      }
    });
  }
}
