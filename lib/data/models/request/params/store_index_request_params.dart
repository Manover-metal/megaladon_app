
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';

class StoreIndexRequestParams {
  int startRow = 0;
  int rowsPerPage = 30;
  String name = '';
  CityModel? city;
  StoreTypeModel? type;


  toData() {
    final data = {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'name': name,
      'city_id': city?.id,
      'type_id': type?.id
    };
    return data;
  }
}