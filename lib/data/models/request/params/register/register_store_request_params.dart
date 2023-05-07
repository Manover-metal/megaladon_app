
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';

class RegisterStoreRequestParams {
  final String name;
  final String bin;
  final String fullAddress;
  final double lon;
  final double lat;
  final CityModel city;
  final StoreTypeModel type;
  final List<ContactModel> contacts;

  const RegisterStoreRequestParams({
    required this.name,
    required this.bin,
    required this.fullAddress,
    required this.lon,
    required this.lat,
    required this.city,
    required this.type,
    required this.contacts
  });

  toData() {
    final data = {
      'name': name,
      'bin': bin,
      'full_address': fullAddress,
      'lon': lon,
      'lat': lat,
      'city_id': city.id,
      'type_id': type.id,
      'contacts': contacts.map((e) {
        return {
          'type': e.type.name,
          'value': e.value,
          'contact_name': e.contactName ?? ''
        };
      }).toList()
    };
    return data;
  }
}
