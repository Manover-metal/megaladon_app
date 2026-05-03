import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  final UserRepository _repository = UserRepository();
  final AuthBloc authBloc;
  
  ProfileScreenCubit(this.authBloc) : super(const ProfileScreenState()) {
    _listen(authBloc.state);
    authBloc.stream.listen(_listen);
  }

  _listen(state) {
    if(state is AuthLoginState) {
      fetch(id: state.auth.user.value!.id);
    } else if(state is AuthInitial || state is AuthLogoutState) {
      emit(const ProfileScreenState(status: ProfileScreenStatus.notAuth));
    }
  }

  Future fetch({required int id}) async {
    emit(const ProfileScreenState(status: ProfileScreenStatus.loading));
    return updateData(id);
  }

  // hoverChangePrice() {
  //   emit(state.copyWith(isUpdatePrice: !state.isUpdatePrice));
  // }

  Future updateData(int id) async {
    return await _repository.profile(id).then((value) {
      UserModel user = UserModel.fromJson(value['user']);
      print(value['user']['executor']);
      print(value['user']['store']);

      ExecutorModel? executor = value['user']['executor'] != null? ExecutorModel.fromJson(value['user']['executor']): null;
      StoreModel? store = value['user']['store'] != null? StoreModel.fromJsonFull(value['user']['store']): null;
      emit(ProfileScreenState(
          status: ProfileScreenStatus.success,
          user: user,
          executor: executor,
          store: store
      ));
    }).catchError(( error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
          emit(const ProfileScreenState(status: ProfileScreenStatus.notAuth));
        } else {
          emit(ProfileScreenState(status: ProfileScreenStatus.error, error: ErrorModel.parseDio(error)));
        }
      } else {
        emit(ProfileScreenState(status: ProfileScreenStatus.error, error: ErrorModel.nothing));
      }
    });
  }
}
