
import 'package:isar/isar.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';

part 'auth_model.g.dart';


@collection
class AuthModel {
  Id id = Isar.autoIncrement;

  late String? token;

  IsarLink<UserModel> user = IsarLink<UserModel>();

  IsarLink<ExecutorModel> executor = IsarLink<ExecutorModel>();

  IsarLink<StoreModel> store = IsarLink<StoreModel>();

}