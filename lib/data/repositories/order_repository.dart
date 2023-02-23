import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';

class OrderRepository {
  Future index(OrderIndexRequestParams params) => ApiService.I
      .get('/order', queryParameters: params.toData())
      .then((value) => OrderModel.listFromJsonMini(value.data['list']));

  Future indexMy(OrderIndexRequestParams params) => ApiService.I
      .get('/order/my', queryParameters: params.toData())
      .then((value) => OrderModel.listFromJsonMini(value.data['list']));

  Future info(int id) => ApiService.I
      .get('/order/$id',)
      .then((value) => OrderModel.fromJsonFull(value.data['order']));

  Future create() => ApiService.I
      .post('/order',)
      .then((value) => value.data);

  Future update(int id) => ApiService.I
      .post('/order/$id/update',)
      .then((value) => value.data);

  Future delete(int id) => ApiService.I
      .delete('/order/$id/delete',)
      .then((value) => value.data);
}

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

enum OrderIndexSort {
  id,
  created_at,
  status,
  category_id;

  @override
  String toString() {
    switch(this) {
      case OrderIndexSort.id: return 'По созданию';
      case OrderIndexSort.created_at: return 'По дате';
      case OrderIndexSort.status: return 'По статусу';
      case OrderIndexSort.category_id: return 'По категории';
    }
  }
}