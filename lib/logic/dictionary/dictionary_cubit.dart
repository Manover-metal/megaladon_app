import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';
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
    await fetchStoreTypes();
  }

  fetchCities()  async {
    await _repository.getCities().then((value) {
      emit(state.copyWith(cities: value));
    });
  }

  fetchOrderCategories()  async {
    await _repository.getOrderCategories().then((value) {
      emit(state.copyWith(orderCategories: value));
    });
  }

  fetchAdvertCategories()  async {
    await _repository.getAdvertCategories().then((value) {
      emit(state.copyWith(advertCategories: value));
    });
  }

  fetchStoreTypes()  async {
    await _repository.getCompanyTypes().then((value) {
      emit(state.copyWith(storeTypes: value));
    });
  }

  fetchServiceTypes()  async {
    await _repository.getServiceTypes().then((value) {
      emit(state.copyWith(serviceTypes: value));
    });
  }
}
