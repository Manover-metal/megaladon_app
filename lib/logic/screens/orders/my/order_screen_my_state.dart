part of 'order_screen_my_cubit.dart';

enum OrderScreenMyStatus { loading, error, success }

/// Состояние экрана «Мои заказы» с двумя независимыми вкладками.
///
/// У каждой вкладки свои статус и ошибка. Раньше поля были общими, и сбой
/// одного списка гасил весь экран: вкладка заказчика показывала ErrorMessage,
/// хотя её собственный запрос вернулся с 200. Особенно заметно это было на
/// пользователях без профиля исполнителя — /order/my-responded отвечал им 404.
class OrderScreenMyState extends Equatable {
  const OrderScreenMyState({
    this.status = OrderScreenMyStatus.success,
    this.statusResponded = OrderScreenMyStatus.success,
    this.orders = const [],
    this.ordersResponded = const [],
    this.error,
    this.errorResponded,
    this.params = const OrderIndexRequestParams(statuses: OrderStatus.values),
    this.stock = false,
    this.stockResponded = false,
  });

  /// Вкладка «как заказчик».
  final OrderScreenMyStatus status;
  final List<OrderModel> orders;
  final ErrorModel? error;
  final bool stock;

  /// Вкладка «как исполнитель».
  final OrderScreenMyStatus statusResponded;
  final List<OrderModel> ordersResponded;
  final ErrorModel? errorResponded;
  final bool stockResponded;

  final OrderIndexRequestParams params;

  // ordersResponded и stockResponded обязаны быть в props: без них Equatable
  // считает состояние неизменившимся, когда обновился только список откликов,
  // и BlocBuilder вкладки «как исполнитель» не перестраивается.
  @override
  List<Object?> get props => [
        status,
        statusResponded,
        orders,
        ordersResponded,
        error,
        errorResponded,
        params,
        stock,
        stockResponded,
      ];

  /// Незаданные поля сохраняются. Ошибки снимаются только явными
  /// [resetError] / [resetErrorResponded] — иначе успешный ответ одного списка
  /// затирал бы ошибку второго, потому что оба пишут в одно состояние.
  OrderScreenMyState copyWith({
    OrderScreenMyStatus? status,
    OrderScreenMyStatus? statusResponded,
    List<OrderModel>? orders,
    List<OrderModel>? ordersResponded,
    ErrorModel? error,
    ErrorModel? errorResponded,
    bool resetError = false,
    bool resetErrorResponded = false,
    OrderIndexRequestParams? params,
    bool? stock,
    bool? stockResponded,
  }) =>
      OrderScreenMyState(
        status: status ?? this.status,
        statusResponded: statusResponded ?? this.statusResponded,
        orders: orders ?? this.orders,
        ordersResponded: ordersResponded ?? this.ordersResponded,
        error: resetError ? null : (error ?? this.error),
        errorResponded: resetErrorResponded
            ? null
            : (errorResponded ?? this.errorResponded),
        params: params ?? this.params,
        stock: stock ?? this.stock,
        stockResponded: stockResponded ?? this.stockResponded,
      );
}
