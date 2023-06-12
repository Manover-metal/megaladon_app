part of 'dictionary_cubit.dart';

class DictionaryState extends Equatable {
  final List<CityModel> cities;
  final List<OrderCategoryModel> orderCategories;
  final List<AdvertCategoryModel> advertCategories;
  final List<StoreTypeModel> storeTypes;
  final List<ServiceTypeModel> serviceTypes;
  final List<SubscribeModel> subscribesStore;
  final List<SubscribeModel> subscribesExecutor;

  const DictionaryState({
    this.cities = const [],
    this.orderCategories = const [],
    this.advertCategories = const [],
    this.storeTypes = const [],
    this.serviceTypes = const [],
    this.subscribesStore = const [],
    this.subscribesExecutor = const []
  });

  DictionaryState copyWith({
    List<CityModel>? cities,
    List<OrderCategoryModel>? orderCategories,
    List<AdvertCategoryModel>? advertCategories,
    List<StoreTypeModel>? storeTypes,
    List<ServiceTypeModel>? serviceTypes,
    List<SubscribeModel>? subscribesStore,
    List<SubscribeModel>? subscribesExecutor
  }) {
    return DictionaryState(
      cities: cities ?? this.cities,
      orderCategories: orderCategories ?? this.orderCategories,
      advertCategories: advertCategories ?? this.advertCategories,
      storeTypes: storeTypes ?? this.storeTypes,
      serviceTypes: serviceTypes ?? this.serviceTypes,
      subscribesExecutor: subscribesExecutor ?? this.subscribesExecutor,
      subscribesStore: subscribesStore ?? this.subscribesStore
    );
  }

  @override
  List<Object?> get props => [cities, orderCategories, advertCategories, storeTypes, serviceTypes, subscribesExecutor, subscribesStore];
}

