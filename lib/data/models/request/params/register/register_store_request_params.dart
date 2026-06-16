import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/company_type_model.dart';

class RegisterStoreRequestParams {
  const RegisterStoreRequestParams(
      {required this.name,
      required this.bin,
      required this.fullAddress,
      required this.lon,
      required this.lat,
      required this.city,
      required this.type,
      required this.contacts});
  final String name;
  final String bin;
  final String fullAddress;
  final double lon;
  final double lat;
  final CityModel city;
  final CompanyTypeModel type;
  final List<ContactModel> contacts;

  Map<String, Object> toData() {
    final data = {
      'name': name,
      'bin': bin,
      'full_address': fullAddress,
      'lon': lon,
      'lat': lat,
      'city_id': city.id,
      'type_id': type.id,
      'contacts': contacts
          .map((e) => {
                'type': e.type.name,
                'value': e.value,
                'contact_name': e.contactName ?? ''
              })
          .toList()
    };
    return data;
  }
}
