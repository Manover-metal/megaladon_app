import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';

class DictionaryRepository {
  Future<List<CityModel>> getCities() => ApiService.I
      .get('/cities')
      .then((value) => CityModel.listFromJson(value.data['list']));

  Future<List<OrderCategoryModel>> getOrderCategories() =>
      ApiService.I.get('/order-categories').then((value) =>
          OrderCategoryModel.listFromJson(value.data['list'] as List<dynamic>));

  Future<List<AdvertCategoryModel>> getAdvertCategories() => ApiService.I
      .get('/advert-categories')
      .then((value) => AdvertCategoryModel.listFromJson(
          value.data['list'] as List<dynamic>));

  Future<List<ServiceTypeModel>> getServiceTypes() =>
      ApiService.I.get('/service-types').then((value) =>
          ServiceTypeModel.listFromJson(value.data['list'] as List<dynamic>));

  Future<List<SubscribeModel>> getSubscribeStore() => ApiService.I
      .get('/subscriptions', queryParameters: {'type': 'store'}).then((value) =>
          SubscribeModel.listFromJson(value.data['list'] as List<dynamic>));

  Future<List<SubscribeModel>> getSubscribeExecutor() => ApiService.I
      .get('/subscriptions', queryParameters: {'type': 'executor'}).then(
          (value) =>
              SubscribeModel.listFromJson(value.data['list'] as List<dynamic>));
}
