import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/create/order_create_request_params.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/data/models/request/params/update/order_update_request_params.dart';

class OrderRepository {
  Future<List<OrderModel>> index(OrderIndexRequestParams params) => ApiService.I
      .get('/order', queryParameters: params.toData())
      .then((value) =>
          OrderModel.listFromJsonMini(value.data['list'] as List<dynamic>));

  Future<List<OrderModel>> indexMy(OrderIndexRequestParams params) =>
      ApiService.I.get('/order/my', queryParameters: params.toData()).then(
          (value) =>
              OrderModel.listFromJsonMini(value.data['list'] as List<dynamic>));

  Future<List<OrderModel>> indexMyResponded(OrderIndexRequestParams params) =>
      ApiService.I
          .get('/order/my-responded', queryParameters: params.toData())
          .then((value) =>
              OrderModel.listFromJsonMini(value.data['list'] as List<dynamic>));

  Future<OrderModel> info(int id) => ApiService.I
      .get(
        '/order/$id',
      )
      .then((value) =>
          OrderModel.fromJsonFull(value.data['order'] as Map<String, dynamic>));

  Future create(OrderCreateRequestParams params) => ApiService.I
      .post('/order/create', data: params.toData())
      .then((value) => value.data);

  Future<void> update(int id, OrderUpdateRequestParams params) =>
      ApiService.I.post('/order/$id/update', data: params.toData());

  Future complete(int id) =>
      ApiService.I.post('/order/$id/complete').then((value) => value.data);

  Future delete(int id) => ApiService.I
      .delete(
        '/order/$id/delete',
      )
      .then((value) => value.data);
}
