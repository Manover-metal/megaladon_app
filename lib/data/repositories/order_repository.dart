import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/order_model.dart';

class OrderRepository {
  Future index(OrderIndexRequestParams params) => ApiService.I
      .get('/order', queryParameters: params.toData())
      .then((value) => OrderModel.listFromJson(value.data['list']));

  Future indexMy(OrderIndexRequestParams params) => ApiService.I
      .get('/order/my', queryParameters: params.toData())
      .then((value) => OrderModel.listFromJson(value.data['list']));

  Future info(int id) => ApiService.I
      .get('/order/$id',)
      .then((value) => value.data);

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
  int? priceMin;
  int? priceMax;
  OrderIndexPeriod last = OrderIndexPeriod.last3day;
  OrderIndexSort sort = OrderIndexSort.id;

  toData() {
    print(last.name);
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'price_min': priceMin,
      'price_max': priceMax,
      'desc': desc? 1: 0,
      'sort': sort.name
    };
    print(data);
    return data;
  }
}
enum OrderIndexPeriod {
  last3day,
  last7day,
  last30day;

  @override
  String toString() {
    switch(this) {
      case OrderIndexPeriod.last3day: return 'За 3 дня';
      case OrderIndexPeriod.last7day: return 'За неделю';
      case OrderIndexPeriod.last30day: return 'За месяц';
    }
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