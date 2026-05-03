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
      refresh();
    } else {
      emit(const OrderScreenMyState());
    }
  }

  Future fetchMy({OrderIndexRequestParams? params}) async {
    // if(state.status == OrderScreenMyStatus.loading
    //     && state.error == null
    // ) return;

    OrderIndexRequestParams mainParams = params ?? state.params;
    emit(state.copyWith(
        status: OrderScreenMyStatus.loading,
        error: null,
      )
    );
    return await _repository.indexMy(mainParams).then((value) {
      final my = value;

      if(mainParams.startRow == 0) {
        emit(state.copyWith(
            orders: my,
            params: mainParams,
            status: OrderScreenMyStatus.success,
            stock: my.length < mainParams.rowsPerPage,
        ));
      } else {
        emit(state.copyWith(
          status: OrderScreenMyStatus.success,
          orders: [...state.orders, ...my],
          params: mainParams,
          stock: my.length < mainParams.rowsPerPage,
        ));
      }
    }).catchError(( error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        } else {
          emit(state.copyWith(error: ErrorModel.parseDio(error)));
        }
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }

  Future fetchResponded({OrderIndexRequestParams? params}) async {
    // if(state.status == OrderScreenMyStatus.loading
    //     && state.error == null
    // ) return;

    OrderIndexRequestParams mainParams = params ?? state.params;
    emit(state.copyWith(
        status: OrderScreenMyStatus.loading,
        error: null,
      )
    );
    return await _repository.indexMyResponded(mainParams).then((value) {
      final myResponded = value;
      print('fetch Responded');

      if(mainParams.startRow == 0) {
        emit(state.copyWith(
            ordersResponded: myResponded,
            params: mainParams,
            status: OrderScreenMyStatus.success,
            stockResponded: myResponded.length < mainParams.rowsPerPage
        ));
        print('fetch startRow == 0 emit');

      } else {
        emit(state.copyWith(
            status: OrderScreenMyStatus.success,
            ordersResponded: [...state.ordersResponded, ...myResponded],
            params: mainParams,
            stockResponded: myResponded.length < mainParams.rowsPerPage
        ));
        print('fetch startRow not 0 emit');

      }
    }).catchError(( error) {
      print('Error Responded: ${error}');
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        } else {
          emit(state.copyWith(error: ErrorModel.parseDio(error)));
        }
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
      _repository.indexMyResponded(mainParams),

    ]).then((value) {
      final my = value[0];
      final myResponded = value[1];


      emit(state.copyWith(
          orders: my,
          params: mainParams,
          status: OrderScreenMyStatus.success,
          stock: my.length < mainParams.rowsPerPage,
          ordersResponded: myResponded,
          stockResponded: myResponded.length < mainParams.rowsPerPage
      ));
    }).catchError(( error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        } else {
          emit(state.copyWith(error: ErrorModel.parseDio(error)));
        }
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