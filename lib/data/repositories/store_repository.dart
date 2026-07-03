import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/request/params/index/store_index_request_params.dart';
import 'package:megaladon/data/models/store_model.dart';

class StoreRepository {
  Future<List<StoreModel>> index(StoreIndexRequestParams params) => ApiService.I
      .get('/store', queryParameters: params.toData())
      .then((value) =>
          StoreModel.fromJsonList(value.data['list'] as List<dynamic>));

  Future<StoreModel> info(int id) => ApiService.I
      .get(
        '/store/$id',
      )
      .then((value) =>
          StoreModel.fromJson(value.data['store'] as Map<String, dynamic>));

  Future createPrice() => ApiService.I
      .post(
        '/order/price',
      )
      .then((value) => value.data);

  Future activatePrice(int id) => ApiService.I
      .post(
        '/store/price/$id/activate',
      )
      .then((value) => value.data);

  Future deactivatePrice(int id) => ApiService.I
      .post(
        '/store/price/$id/deactivate',
      )
      .then((value) => value.data);

  Future deletePrice(int id) => ApiService.I
      .delete(
        '/store/price/$id/delete',
      )
      .then((value) => value.data);

  Future rate(int id, FormData data) => ApiService.I
      .post<dynamic>('/store/$id/rate', data: data)
      .then((value) => value.data);
}
