import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/company_type_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';

class DictionaryRepository {
  Future<List<CityModel>> getCities() => ApiService.I.get('/cities').then(
      (value) => CityModel.listFromJson(value.data['list'] as List<dynamic>));

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

  Future<List<CompanyTypeModel>> getCompanyTypes() =>
      ApiService.I.get('/company-types').then((value) =>
          CompanyTypeModel.listFromJson(value.data['list'] as List<dynamic>));

  Future<List<SubscribeModel>> getSubscribeStore() => _getSubscribes('store');

  Future<List<SubscribeModel>> getSubscribeExecutor() =>
      _getSubscribes('executor');

  /// Общий запрос подписок с логированием сырого ответа: подписки перестали
  /// отображаться, а по пустому списку на экране не понять, вернул ли бэкенд
  /// ничего или ответ не разобрался в [SubscribeModel].
  Future<List<SubscribeModel>> _getSubscribes(String type) async {
    final response = await ApiService.I
        .get<dynamic>('/subscriptions', queryParameters: {'type': type});

    final raw = response.data['list'];
    print('[subscriptions:$type] сырой list: $raw');

    if (raw is! List) {
      throw FormatException(
          '[subscriptions:$type] в поле list ожидался массив, пришло '
          '${raw.runtimeType}; тело ответа: ${response.data}');
    }

    try {
      return SubscribeModel.listFromJson(raw);
    } catch (err, stackTrace) {
      // Разбор падает на конкретном элементе — печатаем его целиком, иначе по
      // тексту исключения не видно, какое поле не совпало с моделью.
      print('[subscriptions:$type] не разобрался ответ: $err');
      print('[subscriptions:$type] элементы: $raw');
      print(stackTrace);
      rethrow;
    }
  }
}
