import 'package:bloc/bloc.dart';
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
    await _repository.getSubscribeStore().then((value) {
      print(value);

      emit(state.copyWith(subscribesStore: value));
    }).catchError((Object err, StackTrace stackTrace) {
      print(err);
      print(stackTrace);

      emit(state.copyWith(subscribesStore: []));
    });
  }

  Future<void> fetchSubscribesExecutor() async {
    await _repository.getSubscribeExecutor().then((value) {
      print(value);
      emit(state.copyWith(subscribesExecutor: value));
    }).catchError((Object err, StackTrace stackTrace) {
      print(err);
      print(stackTrace);

      emit(state.copyWith(subscribesExecutor: []));
    });
  }
}
