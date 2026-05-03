import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/repositories/dictionary_repository.dart';

part 'dictionary_state.dart';

class DictionaryCubit extends Cubit<DictionaryState> {
  final DictionaryRepository _repository = DictionaryRepository();
  DictionaryCubit() : super(DictionaryState());

  initial() async {
    await fetchCities();
    await fetchAdvertCategories();
    await fetchOrderCategories();
    await fetchServiceTypes();
    await fetchSubscribesStore();
    await fetchSubscribesExecutor();
  }

  fetchCities()  async {
    await _repository.getCities().then((value) {
      emit(state.copyWith(cities: value));
    }).catchError((err) {
      emit(state.copyWith(cities: []));

    });
  }

  fetchOrderCategories()  async {
    await _repository.getOrderCategories().then((value) {
      emit(state.copyWith(orderCategories: value));
    }).catchError((err) {
      emit(state.copyWith(orderCategories: []));

    });
  }

  fetchAdvertCategories()  async {
    await _repository.getAdvertCategories().then((value) {
      emit(state.copyWith(advertCategories: value));
    }).catchError((err) {
      emit(state.copyWith(advertCategories: []));

    });
  }

  fetchServiceTypes()  async {
    await _repository.getServiceTypes().then((value) {
      emit(state.copyWith(serviceTypes: value));
    }).catchError((err) {
      emit(state.copyWith(serviceTypes: []));
    });
  }

  fetchSubscribesStore()  async {
    await _repository.getSubscribeStore().then((value) {
      print(value);

      emit(state.copyWith(subscribesStore: value));
    }).catchError((err) {
      print(err);

      emit(state.copyWith(subscribesStore: []));
    });
  }

  fetchSubscribesExecutor()  async {
    await _repository.getSubscribeExecutor().then((value) {
      print(value);
      emit(state.copyWith(subscribesExecutor: value));
    }).catchError((err) {
      print(err);

      emit(state.copyWith(subscribesExecutor: []));
    });
  }
}
