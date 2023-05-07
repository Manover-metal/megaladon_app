
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';



class StoreIndexRequestParams {
  final int startRow;
  final int rowsPerPage;
  final bool desc;
  final CityModel? city;
  final StoreTypeModel? category;
  final IndexPeriod last;

  const StoreIndexRequestParams({
      this.startRow = 0,
      this.rowsPerPage = 15,
      this.desc = false,
      this.city,
      this.category,
      this.last = IndexPeriod.last3day,
  });

  toData() {
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'desc': desc? 1: 0,
      // 'sort': sort.name,
      'city_id': city?.id,
      'category_id': category?.id
    };
    return data;
  }

  StoreIndexRequestParams copyWith({
    int? startRow,
    int? rowsPerPage,
    bool? desc,
    CityModel? city,
    StoreTypeModel? category,
    IndexPeriod? last,
    // StoreIndexSort? sort
  }) {
    return StoreIndexRequestParams(
      startRow: startRow ?? this.startRow,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      desc: desc ?? this.desc,
      city: city ?? this.city,
      category: category ?? this.category,
      last: last ?? this.last,
      // sort: sort ?? this.sort
    );
  }
}

// class StoreIndexRequestParams {
//   int startRow = 0;
//   int rowsPerPage = 30;
//   String name = '';
//   CityModel? city;
//   StoreTypeModel? type;


//   toData() {
//     final data = {
//       'startRow': startRow,
//       'rowsPerPage': rowsPerPage,
//       'name': name,
//       'city_id': city?.id,
//       'type_id': type?.id
//     };
//     return data;
//   }
// }