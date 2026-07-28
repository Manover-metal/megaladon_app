import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';
import 'package:megaladon/data/models/request/order_index_sort_enum.dart';

class OrderIndexRequestParams {
  const OrderIndexRequestParams(
      {this.startRow = 0,
      this.rowsPerPage = 15,
      this.desc = true,
      this.city,
      this.category,
      this.last = IndexPeriod.allTime,
      this.sort = OrderIndexSort.id,
      this.statuses = const [
        OrderStatus.active,
        OrderStatus.hasExecutor,
        OrderStatus.completed,
      ],
      this.userId});
  final int startRow;
  final int rowsPerPage;
  final bool desc;
  final CityModel? city;
  final OrderCategoryModel? category;
  final IndexPeriod last;
  final OrderIndexSort sort;

  /// Статусы заказов, которые нужно отображать. Сюда не попадают
  /// [OrderStatus.moderate] и [OrderStatus.archive], поэтому заказы на
  /// модерации и в архиве не запрашиваются с бэкенда.
  final List<OrderStatus> statuses;

  /// Фильтр по автору. Используется публичной страницей пользователя;
  /// в обычной выдаче ленты заказов не задаётся.
  final int? userId;

  Map<String, Object?> toData() {
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'desc': desc ? 1 : 0,
      'sortBy': sort.name,
      'city_id': city?.id,
      'category':
          category?.id == OrderCategoryModel.nothing.id ? null : category?.id,
      'statuses': statuses.map((status) => status.index).toList(),
    };
    if (userId != null) {
      data['user_id'] = userId;
    }
    return data;
  }

  OrderIndexRequestParams copyWith(
          {int? startRow,
          int? rowsPerPage,
          bool? desc,
          CityModel? city,
          OrderCategoryModel? category,
          IndexPeriod? last,
          OrderIndexSort? sort,
          List<OrderStatus>? statuses,
          int? userId}) =>
      OrderIndexRequestParams(
          startRow: startRow ?? this.startRow,
          rowsPerPage: rowsPerPage ?? this.rowsPerPage,
          desc: desc ?? this.desc,
          city: city ?? this.city,
          category: category ?? this.category,
          last: last ?? this.last,
          sort: sort ?? this.sort,
          statuses: statuses ?? this.statuses,
          userId: userId ?? this.userId);

  /// Like [copyWith], but [city] and [category] are taken verbatim — passing
  /// `null` clears the filter instead of keeping the previous value. Used when
  /// applying filters so a deselected city/category actually resets.
  OrderIndexRequestParams copyWithNull(
          {int? startRow,
          int? rowsPerPage,
          bool? desc,
          CityModel? city,
          OrderCategoryModel? category,
          IndexPeriod? last,
          OrderIndexSort? sort,
          List<OrderStatus>? statuses,
          int? userId}) =>
      OrderIndexRequestParams(
          startRow: startRow ?? this.startRow,
          rowsPerPage: rowsPerPage ?? this.rowsPerPage,
          desc: desc ?? this.desc,
          city: city,
          category: category,
          last: last ?? this.last,
          sort: sort ?? this.sort,
          statuses: statuses ?? this.statuses,
          userId: userId ?? this.userId);
}
