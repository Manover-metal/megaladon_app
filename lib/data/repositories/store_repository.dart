import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/store_model.dart';

class StoreRepository {
  Future index(StoreIndexRequestParams params) => ApiService.I
      .get('/store', queryParameters: params.toData())
      .then((value) => StoreModel.listFromJson(value.data['list']));

  Future info(int id) => ApiService.I
      .get('/order/$id',)
      .then((value) => value.data);

  Future createPrice() => ApiService.I
      .post('/order/price',)
      .then((value) => value.data);

  Future activatePrice(int id) => ApiService.I
      .post('/store/price/$id/activate',)
      .then((value) => value.data);

  Future deactivatePrice(int id) => ApiService.I
      .post('/store/price/$id/deactivate',)
      .then((value) => value.data);

  Future deletePrice(int id) => ApiService.I
      .delete('/store/price/$id/delete',)
      .then((value) => value.data);
}

class StoreIndexRequestParams {
  int startRow = 0;
  int rowsPerPage = 30;
  String name = '';


  toData() {
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'name': name
    };
    return data;
  }
}