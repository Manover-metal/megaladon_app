import 'package:isar/isar.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/user_model.dart';

class IsarService {
  static late Isar _isar;

  static Future initialize() async {
    _isar = await Isar.open([
      UserModelSchema,
      ExecutorModelSchema,
      AuthModelSchema
    ]);
  }

  static Isar get I => _isar;
}
