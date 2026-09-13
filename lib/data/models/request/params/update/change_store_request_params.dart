import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';

/// Изменение магазина. БИН не отправляем: с экрана он не редактируется, а
/// бэкенд обновляет только пришедшие поля — сохранённый БИН остаётся.
class ChangeStoreRequestParams {
  const ChangeStoreRequestParams(
      {required this.name,
      required this.fullAddress,
      required this.lon,
      required this.lat,
      required this.city,
      required this.contacts});
  final String name;
  final String fullAddress;
  final double lon;
  final double lat;
  final CityModel city;
  final List<ContactModel> contacts;

  Map<String, Object> toData() {
    final data = {
      'name': name,
      'full_address': fullAddress,
      'lon': lon,
      'lat': lat,
      'city_id': city.id,
      'contacts': contacts.map((e) {
        if (e.type == ContactType.phone || e.type == ContactType.home_phone) {
          return {
            'type': e.type.name,
            'value': e.value,
            'contact_name': e.contactName ?? ''
          };
        } else {
          return {
            'type': e.type.name,
            'value': e.value,
          };
        }
      }).toList()
    };
    return data;
  }
}
