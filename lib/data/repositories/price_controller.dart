import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';

class PriceController {
  Future addPrice(FormData data) =>
      ApiService.I.post('/store/price', data: data);

  Future deactivatePrice(int id) =>
      ApiService.I.post('/store/price/$id/deactivate');

  Future delete(int id) => ApiService.I.delete('/store/price/$id/delete');

  Future activatePrice(int id) =>
      ApiService.I.post('/store/price/$id/activate');
}
