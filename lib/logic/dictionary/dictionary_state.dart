part of 'dictionary_cubit.dart';

class DictionaryState extends Equatable {
  const DictionaryState(
      {this.cities = const [],
      this.orderCategories = const [],
      this.advertCategories = const [],
      this.companyTypes = const [],
      this.subscribesStore = const [],
      this.subscribesExecutor = const []});
  final List<CityModel> cities;

  /// Деревья: корни, дети — в [CategoryModel.children].
  /// Услуги: заказы, исполнители, объявления-услуги.
  final List<CategoryModel> orderCategories;
  final List<CategoryModel> advertCategories;
  final List<CompanyTypeModel> companyTypes;
  final List<SubscribeModel> subscribesStore;
  final List<SubscribeModel> subscribesExecutor;

  DictionaryState copyWith(
          {List<CityModel>? cities,
          List<CategoryModel>? orderCategories,
          List<CategoryModel>? advertCategories,
          List<CompanyTypeModel>? companyTypes,
          List<SubscribeModel>? subscribesStore,
          List<SubscribeModel>? subscribesExecutor}) =>
      DictionaryState(
          cities: cities ?? this.cities,
          orderCategories: orderCategories ?? this.orderCategories,
          advertCategories: advertCategories ?? this.advertCategories,
          companyTypes: companyTypes ?? this.companyTypes,
          subscribesExecutor: subscribesExecutor ?? this.subscribesExecutor,
          subscribesStore: subscribesStore ?? this.subscribesStore);

  @override
  List<Object?> get props => [
        cities,
        orderCategories,
        advertCategories,
        companyTypes,
        subscribesExecutor,
        subscribesStore
      ];
}
