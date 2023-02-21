import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_my_state.dart';

class OrderScreenMyCubit extends Cubit<OrderScreenMyState> {
  final OrderRepository _repository = OrderRepository();
  OrderScreenMyCubit() : super(OrderScreenMyInitial());

  Future fetch({ OrderIndexRequestParams? params }) async {
    OrderIndexRequestParams mainParams = params ?? state.params;
    emit(OrderScreenMyLoader());
    await _repository.indexMy(mainParams).then((value) {
      if(mainParams.startRow == 0) {
        emit(OrderScreenMySuccess(orders: value, params: mainParams));
      } else {
        emit(OrderScreenMySuccess(
          orders: [...(state as OrderScreenMySuccess).orders, value],
          params: mainParams
        ));
      }
    }).catchError((error) {
      emit(OrderScreenMyError());
    });
  }

  changeParams(OrderIndexRequestParams params) {
    if(state is OrderScreenMySuccess) {
      params.startRow = 0;
      emit((state as OrderScreenMySuccess).copyWith(params: params));
    }
  }
}
