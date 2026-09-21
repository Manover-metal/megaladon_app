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
  /// [repository] подменяется только в тестах: в приложении cubit собирает
  /// зависимость сам. Так же устроен AuthBloc.
  ProfileScreenCubit(this.authBloc, {UserRepository? repository})
      : _repository = repository ?? UserRepository(),
        super(const ProfileScreenState()) {
    _listen(authBloc.state);
    authBloc.stream.listen(_listen);
  }
  final UserRepository _repository;
  final AuthBloc authBloc;

  void _listen(AuthState state) {
    if (state is AuthLoginState) {
      fetch();
    } else if (state is AuthInitial || state is AuthLogoutState) {
      emit(const ProfileScreenState(status: ProfileScreenStatus.notAuth));
    }
  }

  Future fetch() async {
    // Пользователя на время перезагрузки не сбрасываем: по state.user
    // решают, исполнитель ли он (hasExecutor), и с user == null вкладка
    // «Как исполнитель» на каждый refresh профиля превращалась в заглушку.
    emit(ProfileScreenState(
        status: ProfileScreenStatus.loading, user: state.user));
    return updateData();
  }

  bool hasExecutor() => state.user?.executor != null;

  bool hasStore() => state.user?.store != null;

  // hoverChangePrice() {
  //   emit(state.copyWith(isUpdatePrice: !state.isUpdatePrice));
  // }

  Future<void> updateData() async {
    try {
      final result = await _repository.profile();
      emit(
        ProfileScreenState(status: ProfileScreenStatus.success, user: result),
      );
    } catch (err) {
      // Выход из аккаунта здесь не делаем: 401 перехватывает AuthInterceptor,
      // а этот cubit уйдёт в notAuth по AuthLogoutState из _listen(). Раньше
      // 403 («нет доступа») трактовался как мёртвый токен и разлогинивал.
      if (err is DioException) {
        emit(ProfileScreenState(
            status: ProfileScreenStatus.error,
            error: ErrorModel.parseDio(err)));
      } else {
        emit(ProfileScreenState(
            status: ProfileScreenStatus.error, error: ErrorModel.nothing));
      }
    }
  }
}
