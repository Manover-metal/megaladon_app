
import 'package:isar/isar.dart';

part 'auth_model.g.dart';

enum TokenTypeModel {
  user,
  executor,
  store
}

@collection
class AuthModel {
  Id id = Isar.autoIncrement;

  late String? token;

  @enumerated
  late TokenTypeModel type;
}