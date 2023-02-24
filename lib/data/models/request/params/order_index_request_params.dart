import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';
import 'package:megaladon/data/repositories/order_repository.dart';

class OrderIndexRequestParams {
  int startRow = 0;
  int rowsPerPage = 15;
  bool desc = false;
  CityModel? city;
  OrderCategoryModel? category;
  IndexPeriod last = IndexPeriod.last3day;
  OrderIndexSort sort = OrderIndexSort.id;

  toData() {
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'desc': desc? 1: 0,
      'sort': sort.name,
      'city_id': city?.id,
      'category_id': category?.id
    };
    print(data);
    return data;
  }
}