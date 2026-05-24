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

  static AuthModel fromJson(Map<String, dynamic> json) {
    AuthModel auth = AuthModel()..token = json['token']
    ..user.value = UserModel.fromJson(json['user'])
    ..executor.value = ExecutorModel.fromJsonOrNull(json['user']['executor'])
    ..store.value = StoreModel.fromJsonFullOrNull(json['user']['store']);

    return auth;
  } 
}