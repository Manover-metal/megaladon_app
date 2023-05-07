import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/request/params/index/store_index_request_params.dart';
import 'package:megaladon/data/models/store_model.dart';

class StoreRepository {
  Future index(StoreIndexRequestParams params) => ApiService.I
      .get('/store', queryParameters: params.toData())
      .then((value) => StoreModel.listFromJsonMini(value.data['list']));

  Future info(int id) => ApiService.I
      .get('/store/$id',)
      .then((value) => StoreModel.fromJsonFull(value.data['store']));

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