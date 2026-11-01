import 'package:megaladon/data/models/dictionary/category_model.dart';

/// Изменение исполнителя. БИН не отправляем: с экрана он не редактируется, а
/// бэкенд обновляет только пришедшие поля — сохранённый БИН остаётся.
class ChangeExecutorRequestParams {
  const ChangeExecutorRequestParams(
      {required this.name,
      required this.fullAddress,
      this.services = const []});
  final String name;
  final String fullAddress;
  final List<CategoryModel> services;

  Map<String, Object> toData() {
    final data = {
      'name': name,
      'full_address': fullAddress,
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
