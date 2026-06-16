part of 'dictionary_cubit.dart';

class DictionaryState extends Equatable {
  const DictionaryState(
      {this.cities = const [],
      this.orderCategories = const [],
      this.advertCategories = const [],
      this.serviceTypes = const [],
      this.companyTypes = const [],
      this.subscribesStore = const [],
      this.subscribesExecutor = const []});
  final List<CityModel> cities;
  final List<OrderCategoryModel> orderCategories;
  final List<AdvertCategoryModel> advertCategories;
  final List<ServiceTypeModel> serviceTypes;
  final List<CompanyTypeModel> companyTypes;
  final List<SubscribeModel> subscribesStore;
  final List<SubscribeModel> subscribesExecutor;

  DictionaryState copyWith(
          {List<CityModel>? cities,
          List<OrderCategoryModel>? orderCategories,
          List<AdvertCategoryModel>? advertCategories,
          List<ServiceTypeModel>? serviceTypes,
          List<CompanyTypeModel>? companyTypes,
          List<SubscribeModel>? subscribesStore,
          List<SubscribeModel>? subscribesExecutor}) =>
      DictionaryState(
          cities: cities ?? this.cities,
          orderCategories: orderCategories ?? this.orderCategories,
          advertCategories: advertCategories ?? this.advertCategories,
          serviceTypes: serviceTypes ?? this.serviceTypes,
          companyTypes: companyTypes ?? this.companyTypes,
          subscribesExecutor: subscribesExecutor ?? this.subscribesExecutor,
          subscribesStore: subscribesStore ?? this.subscribesStore);

  @override
  List<Object?> get props => [
        cities,
        orderCategories,
        advertCategories,
        serviceTypes,
        companyTypes,
        subscribesExecutor,
        subscribesStore
      ];
}
