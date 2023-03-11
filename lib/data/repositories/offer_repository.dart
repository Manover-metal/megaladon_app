import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/offer_model.dart';
import 'package:megaladon/data/models/request/params/offer_create_request_params.dart';

class OfferRepository {
  Future create(int orderId, OfferCreateRequestParams params) => ApiService.I
      .post('/order/$orderId/offer', data: params.toData())
      .then((value) => value.data);

  Future getAll(int orderId) => ApiService.I
      .get('/order/$orderId/offer')
      .then((value) => OfferModel.listFromJsonMini(value.data['list']));

  Future accept(int orderId, int offerId) => ApiService.I
      .post('/order/$orderId/offer/$offerId')
      .then((value) => value.data);

  Future getById(int orderId, int offerId) => ApiService.I
      .get('/order/$orderId/offer/$offerId')
      .then((value) => OfferModel.fromJsonFull(value.data['offer']));
}