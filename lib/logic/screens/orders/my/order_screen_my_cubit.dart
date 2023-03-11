import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/order_index_request_params.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_my_state.dart';

class OrderScreenMyCubit extends Cubit<OrderScreenMyState> {
  final OrderRepository _repository = OrderRepository();
  OrderScreenMyCubit() : super(const OrderScreenMyState());

  Future fetch({OrderIndexRequestParams? params}) async {
    OrderIndexRequestParams mainParams = params ?? state.params;
    emit(state.copyWith(status: OrderScreenMyStatus.loading, error: null, orders: state.orders));
    return await _repository.index(mainParams).then((value) {
      if(mainParams.startRow == 0) {
        emit(state.copyWith(
            orders: value,
            params: mainParams,
            status: OrderScreenMyStatus.success
          )
        );
      } else {
        emit(state.copyWith(
          status: OrderScreenMyStatus.success,
          orders: [...state.orders, ...value],
          params: mainParams
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


// class OrderScreenMyCubit extends Cubit<OrderScreenMyState> {
//   final OrderRepository _repository = OrderRepository();
//   OrderScreenMyCubit() : super(OrderScreenMyInitial());

//   Future fetch({ OrderIndexRequestParams? params }) async {
//     OrderIndexRequestParams mainParams = params ?? state.params;
//     emit(OrderScreenMyLoader());
//     await _repository.indexMy(mainParams).then((value) {
//       if(mainParams.startRow == 0) {
//         emit(OrderScreenMySuccess(orders: value, params: mainParams));
//       } else {
//         emit(OrderScreenMySuccess(
//           orders: [...(state as OrderScreenMySuccess).orders, value],
//           params: mainParams
//         ));
//       }
//     }).catchError((error) {
//       if(error is DioError) {
//         emit(OrderScreenMyError(ErrorModel.parseDio(error)));
//       } else {
//         emit(OrderScreenMyError(ErrorModel.nothing));
//       }
//     });
//   }

//   changeParams(OrderIndexRequestParams params) {
//     if(state is OrderScreenMySuccess) {
//       emit((state as OrderScreenMySuccess).copyWith(
//           params: params.copyWith(startRow: 0)
//         )
//       );
//     }
//   }
// }
