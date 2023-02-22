import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/advert_model.dart';

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

class AdvertIndexRequestParams {
  int startRow = 0;
  int rowsPerPage = 30;
  int? priceMin;
  int? priceMax;
  AdvertIndexPeriod last = AdvertIndexPeriod.last3day;

  toData() {
    return {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'price_min': priceMin,
      'price_max': priceMax
    };
  }
}
enum AdvertIndexPeriod {
  last3day,
  last7day,
  last30day;

  @override
  String toString() {
    switch(this) {
      case AdvertIndexPeriod.last3day: return '3 дня';
      case AdvertIndexPeriod.last7day: return 'неделю';
      case AdvertIndexPeriod.last30day: return 'месяц';
    }
  }
}