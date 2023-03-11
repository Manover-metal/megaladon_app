import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_details_state.dart';

class OrderScreenDetailsCubit extends Cubit<OrderScreenDetailsState> {
  final OrderRepository _repository = OrderRepository();
  OrderScreenDetailsCubit() : super(OrderScreenDetailsInitial());

  Future fetch({required int id}) async {
    if(state is OrderScreenDetailsSuccess) {
      if((state as OrderScreenDetailsSuccess).order.id == id) return;
    }
    emit(OrderScreenDetailsLoader());
    return await _repository.info(id).then((value) {
      emit(OrderScreenDetailsSuccess(
          order: value
      ));
    }).catchError(( error) {
      if(error is DioError) {
        emit(OrderScreenDetailsError(ErrorModel.parseDio(error)));
      } else {
        emit(OrderScreenDetailsError(ErrorModel.nothing));
      }
    });
  }
}
