import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';
import 'package:megaladon/data/models/request/order_index_sort_enum.dart';

class OrderIndexRequestParams {
  final int startRow;
  final int rowsPerPage;
  final bool desc;
  final CityModel? city;
  final OrderCategoryModel? category;
  final IndexPeriod last;
  final OrderIndexSort sort;

  const OrderIndexRequestParams({
      this.startRow = 0,
      this.rowsPerPage = 15,
      this.desc = true,
      this.city,
      this.category,
      this.last = IndexPeriod.last3day,
      this.sort = OrderIndexSort.id
  });

  toData() {
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'desc': desc? 1: 0,
      'sortBy': sort.name,
      'city_id': city?.id,
      'category_id': category?.id
    };
    return data;
  }

  OrderIndexRequestParams copyWith({
    int? startRow,
    int? rowsPerPage,
    bool? desc,
    CityModel? city,
    OrderCategoryModel? category,
    IndexPeriod? last,
    OrderIndexSort? sort
  }) {
    return OrderIndexRequestParams(
      startRow: startRow ?? this.startRow,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      desc: desc ?? this.desc,
      city: city ?? this.city,
      category: category ?? this.category,
      last: last ?? this.last,
      sort: sort ?? this.sort
    );
  }
}