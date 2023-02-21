import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_main_state.dart';

class OrderScreenMainCubit extends Cubit<OrderScreenMainState> {
  final OrderRepository _repository = OrderRepository();
  OrderScreenMainCubit() : super(OrderScreenMainInitial());

  Future fetch({OrderIndexRequestParams? params}) async {
    OrderIndexRequestParams mainParams = params ?? state.params;
    emit(OrderScreenMainLoader());
    return await _repository.index(mainParams).then((value) {
      if(mainParams.startRow == 0) {
        emit(OrderScreenMainSuccess(orders: value, params: mainParams));
      } else {
        emit(OrderScreenMainSuccess(
          orders: [...(state as OrderScreenMainSuccess).orders, value],
          params: mainParams
        ));
      }
    }).catchError(( error) {
      print(error);
      emit(OrderScreenMainError());
    });
  }

  changeParams(OrderIndexRequestParams params) {
    if(state is OrderScreenMainSuccess) {
      params.startRow = 0;
      emit((state as OrderScreenMainSuccess).copyWith(params: params));
    }
  }
}
