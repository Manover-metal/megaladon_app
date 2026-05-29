import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';

class RegisterExecutorRequestParams {
  const RegisterExecutorRequestParams(
      {required this.name,
      required this.description,
      required this.bin,
      required this.fullAddress,
      required this.lon,
      required this.lat,
      required this.city,
      this.services = const []});
  final String name;
  final String bin;
  final String fullAddress;
  final String description;
  final double lon;
  final double lat;
  final CityModel city;
  final List<ServiceTypeModel> services;

  Map<String, Object> toData() {
    final data = {
      'name': name,
      'bin': bin,
      'full_address': fullAddress,
      'description': description,
      'city_id': city.id,
      'lon': lon,
      'lat': lat,
      'services': services.map((e) => e.id).toList()
    };
    return data;
  }
  //
  // RegisterExecutorRequestParams copyWith({
  //   int? startRow,
  //   int? rowsPerPage,
  //   bool? desc,
  //   CityModel? city,
  //   StoreTypeModel? category,
  //   IndexPeriod? last,
  //   // StoreIndexSort? sort
  // }) {
  //   return RegisterExecutorRequestParams(
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
