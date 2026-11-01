import 'package:megaladon/data/models/dictionary/category_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum AdvertIndexSort {
  newest('new'),
  oldest('old'),
  priceAsc('price_asc'),
  priceDesc('price_desc');

  const AdvertIndexSort(this.apiName);
  final String apiName;

  String localize(AppLocalizations l10n) {
    switch (this) {
      case AdvertIndexSort.newest:
        return l10n.sort_newest;
      case AdvertIndexSort.oldest:
        return l10n.sort_oldest;
      case AdvertIndexSort.priceAsc:
        return l10n.sort_cheap;
      case AdvertIndexSort.priceDesc:
        return l10n.sort_expensive;
    }
  }
}

class AdvertIndexRequestParams {
  const AdvertIndexRequestParams(
      {this.startRow = 0,
      this.rowsPerPage = 15,
      this.desc = false,
      this.priceMin,
      this.priceMax,
      this.last = IndexPeriod.allTime,
      this.type = AdvertType.advert,
      this.query,
      this.category,
      this.city,
      this.withPhoto = false,
      this.sort = AdvertIndexSort.newest,
      this.userId});
  final int startRow;
  final int rowsPerPage;
  final bool desc;
  final int? priceMin;
  final int? priceMax;
  final IndexPeriod last;
  final AdvertType type;

  /// Поиск по заголовку и описанию.
  final String? query;
  final CategoryModel? category;
  final CityModel? city;
  final bool withPhoto;
  final AdvertIndexSort sort;

  /// Фильтр по автору. Используется публичной страницей пользователя;
  /// в обычной выдаче торговой площадки не задаётся.
  final int? userId;

  Map<String, Object?> toData() {
    final data = <String, Object?>{
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'desc': desc ? 1 : 0,
      'price_min': priceMin,
      'price_max': priceMax,
      'type': type.name,
      'q': query,
      'category': category?.id,
      'city_id': city?.id,
      'with_photo': withPhoto ? 1 : 0,
      'sort': sort.apiName,
    };
    if (userId != null) {
      data['user_id'] = userId;
    }
    data.removeWhere((_, value) => value == null);
    return data;
  }

  AdvertIndexRequestParams copyWith(
          {int? startRow,
          int? rowsPerPage,
          bool? desc,
          int? priceMin,
          int? priceMax,
          IndexPeriod? last,
          AdvertType? type,
          int? userId}) =>
      AdvertIndexRequestParams(
          startRow: startRow ?? this.startRow,
          rowsPerPage: rowsPerPage ?? this.rowsPerPage,
          desc: desc ?? this.desc,
          priceMin: priceMin ?? this.priceMin,
          priceMax: priceMax ?? this.priceMax,
          last: last ?? this.last,
          type: type ?? this.type,
          query: query,
          category: category,
          city: city,
          withPhoto: withPhoto,
          sort: sort,
          userId: userId ?? this.userId);

  /// Применение шторки фильтров: все фильтры берутся как есть, `null`
  /// сбрасывает фильтр, а не оставляет прежнее значение.
  AdvertIndexRequestParams withFilters(
          {required String? query,
          required CategoryModel? category,
          required CityModel? city,
          required int? priceMin,
          required int? priceMax,
          required IndexPeriod last,
          required bool withPhoto,
          required AdvertIndexSort sort}) =>
      AdvertIndexRequestParams(
          rowsPerPage: rowsPerPage,
          desc: desc,
          type: type,
          userId: userId,
          query: (query?.trim().isEmpty ?? true) ? null : query!.trim(),
          category: category,
          city: city,
          priceMin: priceMin,
          priceMax: priceMax,
          last: last,
          withPhoto: withPhoto,
          sort: sort);
}
