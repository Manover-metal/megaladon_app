import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/data/repositories/offer_repository.dart';

part 'offer_screen_main_state.dart';

class OfferScreenMainCubit extends Cubit<OfferScreenMainState> {
  final OfferRepository _repository = OfferRepository();
  OfferScreenMainCubit() : super(OfferScreenMainInitial());

  Future fetch({required int orderId}) async {

    emit(OfferScreenMainLoader());
    return await _repository.getAll(orderId).then((value) {
      print(value);
      emit(OfferScreenMainSuccess(
          offers: value,
      ));
    }).catchError((error) {
      print(error);
      if(error is DioError) {
        emit(OfferScreenMainError(ErrorModel.parseDio(error)));
      }else {
        emit(OfferScreenMainError(ErrorModel.nothing));
      }
    });

  }
}
