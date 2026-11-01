import 'package:megaladon/data/models/dictionary/category_model.dart';

class RegisterExecutorRequestParams {
  const RegisterExecutorRequestParams(
      {required this.name,
      required this.bin,
      required this.fullAddress,
      this.services = const []});
  final String name;
  final String bin;
  final String fullAddress;
  final List<CategoryModel> services;

  Map<String, Object> toData() {
    final data = {
      'name': name,
      'bin': bin,
      'full_address': fullAddress,
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
