import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/data/repositories/order_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'order_screen_my_state.dart';

class OrderScreenMyCubit extends Cubit<OrderScreenMyState> {
  final OrderRepository _repository = OrderRepository();
  final AuthBloc authBloc;

  OrderScreenMyCubit(this.authBloc) : super(const OrderScreenMyState()) {
    _listenAuth(authBloc.state);
    authBloc.stream.listen(_listenAuth);
  }

  _listenAuth(stateAuth) {
    if(stateAuth is AuthLoginState) {
      fetch();
    } else {
      emit(const OrderScreenMyState());
    }
  }

  Future fetch({OrderIndexRequestParams? params}) async {
    if(state.status == OrderScreenMyStatus.loading
        && state.error == null
    ) return;

    OrderIndexRequestParams mainParams = params ?? state.params;
    emit(state.copyWith(
        status: OrderScreenMyStatus.loading,
        error: null,
      )
    );
    return await Future.wait([
      _repository.indexMy(mainParams),
      _repository.indexMyResponded(mainParams)
    ]).then((value) {
      final my = value[0];
      final myResponded = value[1];

      if(mainParams.startRow == 0) {
        emit(state.copyWith(
            orders: my,
            ordersResponded: myResponded,
            params: mainParams,
            status: OrderScreenMyStatus.success,
            stock: my.length < mainParams.rowsPerPage,
            stockResponded: myResponded.length < mainParams.rowsPerPage
        ));
      } else {
        emit(state.copyWith(
          status: OrderScreenMyStatus.success,
          orders: [...state.orders, ...my],
          ordersResponded: [...state.ordersResponded, ...myResponded],
          params: mainParams,
          stock: my.length < mainParams.rowsPerPage,
          stockResponded: myResponded.length < mainParams.rowsPerPage
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

  Future refresh() async {
    if(state.status == OrderScreenMyStatus.loading
        && state.error == null
    ) return;

    OrderIndexRequestParams mainParams = state.params.copyWith(startRow: 0);
    return await Future.wait([
      _repository.indexMy(mainParams),
    ]).then((value) {
      final my = value[0];

      emit(state.copyWith(
          orders: my,
          params: mainParams,
          status: OrderScreenMyStatus.success,
          stock: my.length < mainParams.rowsPerPage,
      ));
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