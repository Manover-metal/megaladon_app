import 'package:megaladon/data/models/dictionary/service_type_model.dart';

/// Изменение исполнителя. БИН не отправляем: с экрана он не редактируется, а
/// бэкенд обновляет только пришедшие поля — сохранённый БИН остаётся.
class ChangeExecutorRequestParams {
  const ChangeExecutorRequestParams(
      {required this.name,
      required this.fullAddress,
      required this.lon,
      required this.lat,
      this.services = const []});
  final String name;
  final String fullAddress;
  final double lon;
  final double lat;
  final List<ServiceTypeModel> services;

  Map<String, Object> toData() {
    final data = {
      'name': name,
      'full_address': fullAddress,
      'lon': lon,
      'lat': lat,
      'services': services.map((e) => e.id).toList(),
    };
    return data;
  }
  //
  // ChangeExecutorRequestParams copyWith({
  //   int? startRow,
  //   int? rowsPerPage,
  //   bool? desc,
  //   CityModel? city,
  //   StoreTypeModel? category,
  //   IndexPeriod? last,
  //   // StoreIndexSort? sort
  // }) {
  //   return ChangeExecutorRequestParams(
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
