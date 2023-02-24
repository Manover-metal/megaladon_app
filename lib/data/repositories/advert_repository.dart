import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';
import 'package:megaladon/data/models/request/params/advert_index_request_params.dart';

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

  Future create() => ApiService.I
      .post('/adverts',)
      .then((value) => value.data);

  Future update(int id) => ApiService.I
      .post('/adverts/$id/update',)
      .then((value) => value.data);

  Future delete(int id) => ApiService.I
      .delete('/adverts/$id/delete',)
      .then((value) => value.data);
}
