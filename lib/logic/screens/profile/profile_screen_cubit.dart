import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/user_repository.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  final UserRepository _repository = UserRepository();
  ProfileScreenCubit() : super(ProfileScreenInitial());

  Future fetch({required int id}) async {
    emit(ProfileScreenLoader());
    return await _repository.profile(id).then((value) {
      UserModel user = UserModel.fromJson(value['user']);
      ExecutorModel? executor = value['user']['executor'] != null? ExecutorModel.fromJson(value['user']['executor']): null;
      StoreModel? store = value['user']['store'] != null? StoreModel.fromJsonFull(value['user']['store']): null;
      emit(ProfileScreenSuccess(
          user: user,
          executor: executor,
          store: store
      ));
    }).catchError(( error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          emit(ProfileScreenUnauthorization());
        } else {
          emit(ProfileScreenError(ErrorModel.parseDio(error)));
        }
      } else {
        emit(ProfileScreenError(ErrorModel.nothing));
      }
    });
  }
}
