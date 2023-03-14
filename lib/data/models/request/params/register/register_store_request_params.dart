
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';

class RegisterStoreRequestParams {
  final String name;
  final String bin;
  final String fullAddress;
  final double lon;
  final double lat;
  final CityModel city;

  const RegisterStoreRequestParams({
    required this.name,
    required this.bin,
    required this.fullAddress,
    required this.lon,
    required this.lat,
    required this.city
  });

  toData() {
    final data = {
      'name': name,
      'bin': bin,
      'full_address': fullAddress,
      'lon': lon,
      'lat': lat,
      'city_id': city.id,

    };
    return data;
  }
//
// RegisterStoreRequestParams copyWith({
//   int? startRow,
//   int? rowsPerPage,
//   bool? desc,
//   CityModel? city,
//   StoreTypeModel? category,
//   IndexPeriod? last,
//   // StoreIndexSort? sort
// }) {
//   return RegisterStoreRequestParams(
//     startRow: startRow ?? this.startRow,
//     rowsPerPage: rowsPerPage ?? this.rowsPerPage,
//     desc: desc ?? this.desc,
//     city: city ?? this.city,
//     category: category ?? this.category,
//     last: last ?? this.last,
//     // sort: sort ?? this.sort
//   );
// }
}
