
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';



class StoreIndexRequestParams {
  final int startRow;
  final int rowsPerPage;
  final bool desc;
  final CityModel? city;
  final IndexPeriod last;

  const StoreIndexRequestParams({
      this.startRow = 0,
      this.rowsPerPage = 15,
      this.desc = false,
      this.city,
      this.last = IndexPeriod.last3day,
  });

  toData() {
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'desc': desc? 1: 0,
      // 'sort': sort.name,
      'city_id': city?.id == CityModel.nothing.id ? null : city?.id,
    };
    return data;
  }

  StoreIndexRequestParams copyWith({
    int? startRow,
    int? rowsPerPage,
    bool? desc,
    CityModel? city,
    IndexPeriod? last,
    // StoreIndexSort? sort
  }) {
    return StoreIndexRequestParams(
      startRow: startRow ?? this.startRow,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      desc: desc ?? this.desc,
      city: city ?? this.city,
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