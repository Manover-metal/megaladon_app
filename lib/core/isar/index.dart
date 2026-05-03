import 'package:isar/isar.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static late Isar _isar;

  static Future initialize() async {
    _isar = await Isar.open([
      UserModelSchema,
      ExecutorModelSchema,
      StoreModelSchema,
      AuthModelSchema
    ],
      directory: (await getApplicationDocumentsDirectory()).path,
      inspector: true
    );
  }

  static Isar get I => _isar;
}
