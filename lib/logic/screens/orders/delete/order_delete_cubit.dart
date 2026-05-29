import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_delete_state.dart';

class OrderDeleteCubit extends Cubit<OrderDeleteState> {
  OrderDeleteCubit() : super(OrderDeleteInitial());

  final OrderRepository _repository = OrderRepository();

  Future<void> delete(int id) async {
    if (state is OrderDeleteLoading) return;

    emit(OrderDeleteLoading());

    await _repository.delete(id).then((_) {
      emit(OrderDeleteSuccess());
    }).catchError((Object error) {
      if (error is DioException) {
        emit(OrderDeleteError(ErrorModel.parseDio(error)));
      } else {
        emit(OrderDeleteError(ErrorModel.nothing));
      }
    });
  }
}
