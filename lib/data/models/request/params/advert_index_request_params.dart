import 'package:megaladon/data/models/request/index_period_enum.dart';

class AdvertIndexRequestParams {
  final int startRow;
  final int rowsPerPage;
  final bool desc;
  final int? priceMin;
  final int? priceMax;
  final IndexPeriod last;

  const AdvertIndexRequestParams({
    this.startRow = 0,
    this.rowsPerPage = 15,
    this.desc = false,
    this.priceMin,
    this.priceMax,
    this.last = IndexPeriod.last3day,
  });

  toData() {
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'desc': desc ? 1 : 0,
      'priceMin': priceMin,
      'priceMax': priceMax
    };
    return data;
  }

  AdvertIndexRequestParams copyWith(
 { int? startRow,
  int? rowsPerPage,
  bool? desc,
  int? priceMin,
  int? priceMax,
  IndexPeriod? last,}
  ) {
    return AdvertIndexRequestParams(
      startRow: startRow ?? this.startRow,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      desc: desc ?? this.desc,
      priceMax: priceMin ?? this.priceMin,
      priceMin: priceMax ?? this.priceMax,
      last: last ?? this.last,
    );
  }
}
// class AdvertIndexRequestParams {
//   int startRow = 0;
//   int rowsPerPage = 30;
//   int? priceMin;
//   int? priceMax;
//   IndexPeriod last = IndexPeriod.last3day;

//   toData() {
//     return {
//       'startRow': startRow,
//       'rowsPerPage': rowsPerPage,
//       'last': last.name,
//       'price_min': priceMin,
//       'price_max': priceMax
//     };
//   }
// }