import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit(this.authBloc) : super(const ProfileScreenState()) {
    _listen(authBloc.state);
    authBloc.stream.listen(_listen);
  }
  final UserRepository _repository = UserRepository();
  final AuthBloc authBloc;

  void _listen(AuthState state) {
    if (state is AuthLoginState) {
      fetch();
    } else if (state is AuthInitial || state is AuthLogoutState) {
      emit(const ProfileScreenState(status: ProfileScreenStatus.notAuth));
    }
  }

  Future fetch() async {
    emit(const ProfileScreenState(status: ProfileScreenStatus.loading));
    return updateData();
  }

  bool hasExecutor() => state.user?.executor != null;

  bool hasStore() => state.user?.store != null;

  // hoverChangePrice() {
  //   emit(state.copyWith(isUpdatePrice: !state.isUpdatePrice));
  // }

  Future updateData() async => await _repository.profile().then((value) {
        emit(
          ProfileScreenState(status: ProfileScreenStatus.success, user: value),
        );
      }).catchError((error, stackTrace) {
        print(error);
        print(stackTrace);
        if (error is DioException) {
          if (error.response?.statusCode == 403) {
            authBloc.add(AuthLogoutEvent());
            emit(const ProfileScreenState(status: ProfileScreenStatus.notAuth));
          } else {
            emit(ProfileScreenState(
                status: ProfileScreenStatus.error,
                error: ErrorModel.parseDio(error)));
          }
        } else {
          emit(ProfileScreenState(
              status: ProfileScreenStatus.error, error: ErrorModel.nothing));
        }
      });
}
