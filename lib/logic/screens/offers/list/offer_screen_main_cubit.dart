import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/data/repositories/offer_repository.dart';

part 'offer_screen_main_state.dart';

class OfferScreenMainCubit extends Cubit<OfferScreenMainState> {
  OfferScreenMainCubit() : super(OfferScreenMainInitial());
  final OfferRepository _repository = OfferRepository();

  Future fetch({required int orderId}) async {
    emit(OfferScreenMainLoader());
    return await _repository.getAll(orderId).then((value) {
      emit(OfferScreenMainSuccess(
        offers: value,
      ));
    }).catchError((error) {
      if (error is DioException) {
        emit(OfferScreenMainError(ErrorModel.parseDio(error)));
      } else {
        emit(OfferScreenMainError(ErrorModel.nothing));
      }
    });
  }
}
