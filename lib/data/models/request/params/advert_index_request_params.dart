
import 'package:megaladon/data/models/request/index_period_enum.dart';

class AdvertIndexRequestParams {
  int startRow = 0;
  int rowsPerPage = 30;
  int? priceMin;
  int? priceMax;
  IndexPeriod last = IndexPeriod.last3day;

  toData() {
    return {
      'startRow': startRow,
      'rowsPerPage': rowsPerPage,
      'last': last.name,
      'price_min': priceMin,
      'price_max': priceMax
    };
  }
}