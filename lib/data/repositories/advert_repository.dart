import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/request/params/create/advert_create_request_params.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/data/models/request/params/update/advert_update_request_params.dart';

class AdvertRepository {
  Future index(AdvertIndexRequestParams params) => ApiService.I
      .get('/adverts', queryParameters: params.toData())
      .then((value) => AdvertModel.listFromJsonMini(value.data['list']));

  Future indexMy(AdvertIndexRequestParams params) => ApiService.I
      .get('/adverts/my', queryParameters: params.toData())
      .then((value) => AdvertModel.listFromJsonMini(value.data['list']));

  Future info(int id) => ApiService.I
      .get('/adverts/$id',)
      .then((value) => AdvertModel.fromJsonAll(value.data['advert']));

  Future create(AdvertCreateRequestParams params) => ApiService.I
      .post('/adverts', data: params.toData())
      .then((value) => value.data);

  Future update(int id, AdvertUpdateRequestParams params) => ApiService.I
      .post('/adverts/$id/update', data: params.toData())
      .then((value) => value.data);

  Future delete(int id) => ApiService.I
      .delete('/adverts/$id/delete',)
      .then((value) => value.data);
}
