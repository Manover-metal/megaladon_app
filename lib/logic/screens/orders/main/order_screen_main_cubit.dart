import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_main_state.dart';

class OrderScreenMainCubit extends Cubit<OrderScreenMainState> {
  final OrderRepository _repository = OrderRepository();
  OrderScreenMainCubit() : super(const OrderScreenMainState());

  Future fetch({OrderIndexRequestParams? params}) async {
    if(state.status == OrderScreenMainStatus.loading
        && state.error == null
    ) return;

    OrderIndexRequestParams mainParams = params ?? state.params;
    emit(state.copyWith(
        status: OrderScreenMainStatus.loading,
        error: null,
        orders: state.orders,
      )
    );
    return await _repository.index(mainParams).then((value) {
      if(mainParams.startRow == 0) {
        emit(state.copyWith(
            orders: value,
            params: mainParams,
            status: OrderScreenMainStatus.success,
            stock: value.length < mainParams.rowsPerPage
          )
        );

      } else {
        emit(state.copyWith(
          status: OrderScreenMainStatus.success,
          orders: [...state.orders, ...value],
          params: mainParams,
          stock: value.length < mainParams.rowsPerPage
        ));
      }
    }).catchError(( error) {
      if(error is DioError) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }


  changeParams(OrderIndexRequestParams params) {
    emit(state.copyWith(
        params: params.copyWith(startRow: 0)
    ));
  }
}
