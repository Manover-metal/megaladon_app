import 'package:megaladon/data/models/dictionary/store_type_model.dart';

class Parser {
  static int toInt(value) {
    switch(value.runtimeType) {
      case String: {
        return int.parse(value);
      }
      case double: {
        return value.toInt();
      }
      case int: {
        return value;
      }
      default: return 0;
    }
  }

  static double toDouble(value) {
    switch(value.runtimeType) {
      case String: {
        return double.parse(value);
      }
      case int: {
        return value.toDouble();
      }
      case double: {
        return value;
      }
      default: return 0.0;
    }
  }

  static StoreTypeModel toStoreType(value) {
    switch(value.runtimeType) {
      case String: {
        return StoreTypeModel(id: 1, name: value);
      }
      case Null: {
        return StoreTypeModel.nothing;
      }
      default: {
        return StoreTypeModel.fromJson(value);
      }
    }
  }
}
