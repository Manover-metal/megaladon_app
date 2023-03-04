
import 'package:isar/isar.dart';
import 'package:megaladon/data/models/user_model.dart';

part 'auth_model.g.dart';


@collection
class AuthModel {
  Id id = Isar.autoIncrement;

  late String? token;

  late UserModel? user;

}