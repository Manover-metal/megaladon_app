import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/company_type_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/repositories/dictionary_repository.dart';

part 'dictionary_state.dart';

class DictionaryCubit extends Cubit<DictionaryState> {
  DictionaryCubit() : super(const DictionaryState());
  final DictionaryRepository _repository = DictionaryRepository();

  Future<void> initial() async {
    await fetchCities();
    await fetchAdvertCategories();
    await fetchOrderCategories();
    await fetchServiceTypes();
    await fetchCompanyTypes();
    await fetchSubscribesStore();
    await fetchSubscribesExecutor();
  }

  Future<void> fetchCities() async {
    await _repository.getCities().then((value) {
      for (final c in value) {
        print(c.name);
      }
      emit(state.copyWith(cities: value));
    }).catchError((Object err, StackTrace stackTrace) {
      print(err);
      print(stackTrace);
      emit(state.copyWith(cities: []));
    });
  }

  Future<void> fetchOrderCategories() async {
    await _repository.getOrderCategories().then((value) {
      emit(state.copyWith(orderCategories: value));
    }).catchError((Object err, StackTrace stackTrace) {
      print(err);
      print(stackTrace);

      emit(state.copyWith(orderCategories: []));
    });
  }

  Future<void> fetchAdvertCategories() async {
    await _repository.getAdvertCategories().then((value) {
      emit(state.copyWith(advertCategories: value));
    }).catchError((Object err, StackTrace stackTrace) {
      print(err);
      print(stackTrace);

      emit(state.copyWith(advertCategories: []));
    });
  }

  Future<void> fetchServiceTypes() async {
    await _repository.getServiceTypes().then((value) {
      emit(state.copyWith(serviceTypes: value));
    }).catchError((Object err, StackTrace stackTrace) {
      print(err);
      print(stackTrace);

      emit(state.copyWith(serviceTypes: []));
    });
  }

  Future<void> fetchCompanyTypes() async {
    await _repository.getCompanyTypes().then((value) {
      emit(state.copyWith(companyTypes: value));
    }).catchError((Object err, StackTrace stackTrace) {
      print(err);
      print(stackTrace);

      emit(state.copyWith(companyTypes: []));
    });
  }

  Future<void> fetchSubscribesStore() async {
    try {
      final value = await _repository.getSubscribeStore();
      print('[subscriptions:store] получено ${value.length} шт.');
      emit(state.copyWith(subscribesStore: value));
    } catch (err, stackTrace) {
      _logSubscribesFailure('store', err, stackTrace);
      emit(state.copyWith(subscribesStore: []));
    }
  }

  Future<void> fetchSubscribesExecutor() async {
    try {
      final value = await _repository.getSubscribeExecutor();
      print('[subscriptions:executor] получено ${value.length} шт.');
      emit(state.copyWith(subscribesExecutor: value));
    } catch (err, stackTrace) {
      _logSubscribesFailure('executor', err, stackTrace);
      emit(state.copyWith(subscribesExecutor: []));
    }
  }

  /// При любой ошибке список подписок подменяется пустым, и экран выглядит так
  /// же, как при честном пустом ответе. Поэтому причину печатаем подробно:
  /// у [DioException] отдельно статус, путь и тело — по ним сразу видно, дошёл
  /// ли запрос до сервера и что он ответил.
  void _logSubscribesFailure(String type, Object err, StackTrace stackTrace) {
    if (err is DioException) {
      print('[subscriptions:$type] запрос не удался: ${err.type}');
      print('[subscriptions:$type] url: ${err.requestOptions.uri}');
      print('[subscriptions:$type] статус: ${err.response?.statusCode}');
      print('[subscriptions:$type] тело: ${err.response?.data}');
    } else {
      print('[subscriptions:$type] ошибка обработки ответа: $err');
    }
    print(stackTrace);
  }
}
