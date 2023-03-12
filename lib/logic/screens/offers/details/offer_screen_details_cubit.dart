import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/data/repositories/offer_repository.dart';

part 'offer_screen_details_state.dart';

class OfferScreenDetailsCubit extends Cubit<OfferScreenDetailsState> {
  final OfferRepository _repository = OfferRepository();
  OfferScreenDetailsCubit() : super(OfferScreenDetailsInitial());

  Future fetch({required int orderId, required int offerId}) async {
    if(state is OfferScreenDetailsSuccess) {
      if((state as OfferScreenDetailsSuccess).offer.id == offerId) return;
    }
    emit(OfferScreenDetailsLoader());
    return await _repository.getById(orderId, offerId).then((value) {
      emit(OfferScreenDetailsSuccess(
          offer: value
      ));
    }).catchError(( error) {
      if(error is DioError) {
        emit(OfferScreenDetailsError(ErrorModel.parseDio(error)));
      } else {
        emit(OfferScreenDetailsError(ErrorModel.nothing));
      }
    });
  }
}
