
import 'package:megaladon/data/models/dictionary/city_model.dart';

class RegisterUserRequestParams {
  final String name;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final CityModel city;

  const RegisterUserRequestParams({
    required this.name,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.city
  });

  toData() {
    final data = {
      'name': name,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'city': city.id,
    };
    return data;
  }
//
// RegisterUserRequestParams copyWith({
//   int? startRow,
//   int? rowsPerPage,
//   bool? desc,
//   CityModel? city,
//   StoreTypeModel? category,
//   IndexPeriod? last,
//   // StoreIndexSort? sort
// }) {
//   return RegisterUserRequestParams(
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
