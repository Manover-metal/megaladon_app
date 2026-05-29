import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/repositories/offer_repository.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_details_state.dart';

class OrderScreenDetailsCubit extends Cubit<OrderScreenDetailsState> {
  OrderScreenDetailsCubit() : super(const OrderScreenDetailsState());
  final OrderRepository _repository = OrderRepository();
  final OfferRepository _offerRepository = OfferRepository();

  Future fetch({required int id}) async {
    emit(state.copyWith(status: OrderScreenDetailsStateStatus.loading));

    return await _fetch(id);
  }

  Future complete() async {
    if (state.status == OrderScreenDetailsStateStatus.success) {
      return await _repository
          .complete(state.order!.id)
          .then((value) async => await _fetch(state.order!.id))
          .catchError((error) {
        if (error is DioException) {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.errorMessage,
              errorMessage: ErrorModel.parseDio(error)));
        } else {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.errorMessage,
              errorMessage: ErrorModel.nothing));
        }
        return Future.error(false);
      });
    }
    return Future.error(false);
  }

  Future acceptOffer({required int orderId, required int offerId}) async =>
      await _offerRepository
          .accept(orderId, offerId)
          .then((value) async => await _fetch(orderId))
          .catchError((error) {
        if (error is DioException) {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.errorMessage,
              errorMessage: ErrorModel.parseDio(error)));
        } else {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.errorMessage,
              errorMessage: ErrorModel.nothing));
        }
        return Future.error(false);
      });

  Future _fetch(int id) async => await _repository.info(id).then((value) {
        emit(state.copyWith(
          order: value,
          status: OrderScreenDetailsStateStatus.success,
        ));
      }).catchError((error) {
        if (error is DioException) {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.error,
              error: ErrorModel.parseDio(error)));
        } else {
          emit(state.copyWith(
              status: OrderScreenDetailsStateStatus.error,
              error: ErrorModel.nothing));
        }
      });
}
