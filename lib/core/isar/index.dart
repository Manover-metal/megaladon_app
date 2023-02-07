import 'package:isar/isar.dart';
import 'package:megaladon/data/models/auth_model.dart';

class IsarService {
  static late Isar _isar;

  static Future initialize() async {
    _isar = await Isar.open([
      AuthModelSchema
    ]);
  }

  static Isar get I => _isar;
}
