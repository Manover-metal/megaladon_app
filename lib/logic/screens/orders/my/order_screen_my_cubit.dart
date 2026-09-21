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
  /// [repository] подменяется только в тестах: в приложении cubit собирает
  /// зависимость сам. Так же устроен AuthBloc.
  OrderScreenMyCubit(this.authBloc, {OrderRepository? repository})
      : _repository = repository ?? OrderRepository(),
        super(const OrderScreenMyState()) {
    _listenAuth(authBloc.state);
    authBloc.stream.listen(_listenAuth);
  }
  final OrderRepository _repository;
  final AuthBloc authBloc;

  void _listenAuth(stateAuth) {
    if (stateAuth is AuthLoginState) {
      refresh();
    } else {
      emit(const OrderScreenMyState());
    }
  }

  Future fetchMy({OrderIndexRequestParams? params}) async {
    // if(state.status == OrderScreenMyStatus.loading
    //     && state.error == null
    // ) return;

    var mainParams = params ?? state.params;
    emit(state.copyWith(
      status: OrderScreenMyStatus.loading,
      resetError: true,
    ));
    return await _repository.indexMy(mainParams).then((value) {
      final my = value;

      if (mainParams.startRow == 0) {
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
    }).catchError((error, stackTrace) {
      print(error);
      print(stackTrace);
      if (error is DioException) {
        _emitMyError(ErrorModel.parseDio(error));
      } else {
        _emitMyError(ErrorModel.nothing);
      }
    });
  }

  Future fetchResponded({OrderIndexRequestParams? params}) async {
    // if(state.status == OrderScreenMyStatus.loading
    //     && state.error == null
    // ) return;

    var mainParams = params ?? state.params;
    emit(state.copyWith(
      statusResponded: OrderScreenMyStatus.loading,
      resetErrorResponded: true,
    ));
    return await _repository.indexMyResponded(mainParams).then((value) {
      final myResponded = value;
      print('fetch Responded');

      if (mainParams.startRow == 0) {
        emit(state.copyWith(
            ordersResponded: myResponded,
            params: mainParams,
            statusResponded: OrderScreenMyStatus.success,
            stockResponded: myResponded.length < mainParams.rowsPerPage));
        print('fetch startRow == 0 emit');
      } else {
        emit(state.copyWith(
            statusResponded: OrderScreenMyStatus.success,
            ordersResponded: [...state.ordersResponded, ...myResponded],
            params: mainParams,
            stockResponded: myResponded.length < mainParams.rowsPerPage));
        print('fetch startRow not 0 emit');
      }
    }).catchError((error) {
      print('Error Responded: $error');
      if (error is DioException) {
        _emitRespondedError(ErrorModel.parseDio(error));
      } else {
        _emitRespondedError(ErrorModel.nothing);
      }
    });
  }

  /// Ошибку обязательно сопровождаем сменой статуса: экран показывает
  /// [ErrorMessage] по `status == error`, а без него оставался бы полностью
  /// пустым — ни списка, ни лоадера, ни текста ошибки.
  ///
  /// Эмиттеры раздельные: вкладки независимы, и сбой одной не должен гасить
  /// вторую.
  void _emitMyError(ErrorModel error) => emit(
        state.copyWith(status: OrderScreenMyStatus.error, error: error),
      );

  void _emitRespondedError(ErrorModel error) => emit(
        state.copyWith(
          statusResponded: OrderScreenMyStatus.error,
          errorResponded: error,
        ),
      );

  /// Обновление обоих списков с первой страницы.
  ///
  /// Списки грузятся независимо. Раньше здесь был `Future.wait` по двум
  /// запросам сразу: он отклоняется целиком при падении любого из них, и
  /// успешно полученные «мои» заказы не доходили до emit — экран оставался
  /// пустым, хотя ответ по ним пришёл с 200. Теперь сбой одного списка
  /// затрагивает только его.
  Future refresh() async {
    if (state.status == OrderScreenMyStatus.loading &&
        state.statusResponded == OrderScreenMyStatus.loading &&
        state.error == null &&
        state.errorResponded == null) return;

    final mainParams = state.params.copyWith(startRow: 0);

    // fetchMy и fetchResponded гасят свои ошибки сами, поэтому wait здесь
    // безопасен — он лишь дожидается обоих.
    await Future.wait([
      fetchMy(params: mainParams),
      fetchResponded(params: mainParams),
    ]);
  }

  void changeParams(OrderIndexRequestParams params) {
    emit(state.copyWith(params: params.copyWith(startRow: 0)));
  }
}
