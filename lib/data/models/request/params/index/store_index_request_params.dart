import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum StoreIndexSort {
  newest('new'),
  rating('rating'),
  name('name');

  const StoreIndexSort(this.apiName);
  final String apiName;

  String localize(AppLocalizations l10n) {
    switch (this) {
      case StoreIndexSort.newest:
        return l10n.sort_newest;
      case StoreIndexSort.rating:
        return l10n.sort_by_rating;
      case StoreIndexSort.name:
        return l10n.sort_by_name;
    }
  }
}

class StoreIndexRequestParams {
  const StoreIndexRequestParams({
    this.startRow = 0,
    this.rowsPerPage = 15,
    this.desc = false,
    this.city,
    this.last = IndexPeriod.allTime,
    this.name,
    this.ratingMin,
    this.sort = StoreIndexSort.newest,
  });
  final int startRow;
  final int rowsPerPage;
  final bool desc;
  final CityModel? city;
  final IndexPeriod last;
  final String? name;
  final int? ratingMin;
  final StoreIndexSort sort;

  Map<String, Object?> toData() {
    final data = <String, Object?>{
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'desc': desc ? 1 : 0,
      'city_id': city?.id,
      'name': name,
      'rating_min': ratingMin,
      'sort': sort.apiName,
    }..removeWhere((_, value) => value == null);
    return data;
  }

  StoreIndexRequestParams copyWith({
    int? startRow,
    int? rowsPerPage,
    bool? desc,
    CityModel? city,
    IndexPeriod? last,
  }) =>
      StoreIndexRequestParams(
        startRow: startRow ?? this.startRow,
        rowsPerPage: rowsPerPage ?? this.rowsPerPage,
        desc: desc ?? this.desc,
        city: city ?? this.city,
        last: last ?? this.last,
        name: name,
        ratingMin: ratingMin,
        sort: sort,
      );

  /// Применение шторки фильтров: `null` сбрасывает фильтр.
  StoreIndexRequestParams withFilters({
    required CityModel? city,
    required String? name,
    required int? ratingMin,
    required StoreIndexSort sort,
  }) =>
      StoreIndexRequestParams(
        rowsPerPage: rowsPerPage,
        desc: desc,
        last: last,
        city: city,
        name: (name?.trim().isEmpty ?? true) ? null : name!.trim(),
        ratingMin: ratingMin,
        sort: sort,
      );
}
