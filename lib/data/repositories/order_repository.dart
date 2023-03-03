import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/order_create_request_params.dart';
import 'package:megaladon/data/models/request/params/order_index_request_params.dart';
import 'package:megaladon/data/models/request/params/order_update_request_params.dart';

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

  Future<OrderModel> create(OrderCreateRequestParams params) => ApiService.I
      .post('/order', queryParameters: params.toData())
      .then((value) => OrderModel.fromJsonFull(value.data['order']));

  Future<OrderModel> update(int id, OrderUpdateRequestParams params) => ApiService.I
      .post('/order/$id/update', data: params.toData())
      .then((value) => OrderModel.fromJsonFull(value.data['order']));

  Future delete(int id) => ApiService.I
      .delete('/order/$id/delete',)
      .then((value) => value.data);
}


