import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/order_index_request_params.dart';
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
      if(error is DioError) {
        emit(OrderScreenMainError(ErrorModel.parseDio(error)));
      }
    });
  }

  changeParams(OrderIndexRequestParams params) {
    if(state is OrderScreenMainSuccess) {
      params.startRow = 0;
      emit((state as OrderScreenMainSuccess).copyWith(params: params));
    }
  }
}
