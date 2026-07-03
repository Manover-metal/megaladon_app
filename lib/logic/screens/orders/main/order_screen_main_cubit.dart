import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/order_index_sort_enum.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

part 'order_screen_main_state.dart';

class OrderScreenMainCubit extends Cubit<OrderScreenMainState> {
  // Список заказов (только этот экран) по умолчанию: показываем статусы
  // active / hasExecutor / completed (это дефолт OrderIndexRequestParams.statuses)
  // и автоматически сортируем по статусу по возрастанию — active → В работе →
  // Выполнен (status 2 → 3 → 4). Другие списки заказов используют свои кубиты
  // со своими дефолтами, поэтому изменение их не затрагивает.
  OrderScreenMainCubit()
      : super(const OrderScreenMainState(
          params: OrderIndexRequestParams(
            sort: OrderIndexSort.status,
            desc: false,
          ),
        ));
  final OrderRepository _repository = OrderRepository();

  Future fetch({OrderIndexRequestParams? params}) async {
    if (state.status == OrderScreenMainStatus.loading && state.error == null)
      return;

    var mainParams = params ?? state.params;
    emit(state.copyWith(
      status: OrderScreenMainStatus.loading,
      error: null,
      orders: state.orders,
    ));
    return await _repository.index(mainParams).then((value) {
      if (mainParams.startRow == 0) {
        emit(state.copyWith(
            orders: value,
            params: mainParams,
            status: OrderScreenMainStatus.success,
            stock: value.length < mainParams.rowsPerPage));
      } else {
        emit(state.copyWith(
            status: OrderScreenMainStatus.success,
            orders: [...state.orders, ...value],
            params: mainParams,
            stock: value.length < mainParams.rowsPerPage));
      }
    }).catchError((error) {
      if (error is DioException) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }

  void changeParams(OrderIndexRequestParams params) {
    emit(state.copyWith(params: params.copyWith(startRow: 0)));
  }

  /// Обновление списка: сбрасываем пагинацию на первую страницу
  /// (startRow → 0, rowsPerPage → дефолт), сохраняя фильтры и сортировку.
  /// Без сброса startRow refresh после бесконечного скролла уходит в ветку
  /// дозагрузки в [fetch] вместо перезагрузки списка.
  Future<void> refresh() =>
      fetch(params: state.params.copyWith(startRow: 0, rowsPerPage: 15));
}
