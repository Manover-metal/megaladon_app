import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/repositories/offer_repository.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_details_state.dart';

class OrderScreenDetailsCubit extends Cubit<OrderScreenDetailsState> {
  final OrderRepository _repository = OrderRepository();
  final OfferRepository _offerRepository = OfferRepository();

  OrderScreenDetailsCubit() : super(OrderScreenDetailsState());

  Future fetch({required int id}) async {
    emit(state.copyWith(
      status: OrderScreenDetailsStateStatus.loading
    ));

    return await _fetch(id);
  }

  Future complete() async {
    if(state.status == OrderScreenDetailsStateStatus.success) {
      return await _repository.complete(state.order!.id).then((value) async {
        return await _fetch(state.order!.id);
      }).catchError((error) {
        if(error is DioError) {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.errorMessage,
              errorMessage: ErrorModel.parseDio(error)
          ));
        } else {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.errorMessage,
              errorMessage: ErrorModel.nothing
          ));
        }
        return Future.error(false);
      });
    }
    return Future.error(false);
  }

  Future acceptOffer({required int orderId, required int offerId}) async {
    return await _offerRepository.accept(orderId, offerId).then((value) async {
      return await _fetch(orderId);
    }).catchError((error) {
      if(error is DioError) {
        emit(state.copyWith(
            status: OrderScreenDetailsStateStatus.errorMessage,
            errorMessage: ErrorModel.parseDio(error)
        ));
      } else {
        emit(state.copyWith(
            status: OrderScreenDetailsStateStatus.errorMessage,
            errorMessage: ErrorModel.nothing
        ));
      }
      return Future.error(false);
    });

  }

  Future _fetch(int id) async {
    return await _repository.info(id).then((value) {
      emit(state.copyWith(
        order: value,
        status: OrderScreenDetailsStateStatus.success,
      ));
    }).catchError(( error) {
      if(error is DioError) {
        emit(state.copyWith(
            status: OrderScreenDetailsStateStatus.error,
            error: ErrorModel.parseDio(error)
        ));
      } else {
        emit(state.copyWith(
            status: OrderScreenDetailsStateStatus.error,
            error: ErrorModel.nothing
        ));
      }
    });
  }


}
