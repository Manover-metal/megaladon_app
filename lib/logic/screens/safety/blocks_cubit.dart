import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/repositories/safety_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

enum BlocksStatus { initial, loading, success, error }

class BlocksState extends Equatable {
  const BlocksState({
    this.status = BlocksStatus.initial,
    this.users = const [],
    this.error,
  });

  final BlocksStatus status;
  final List<UserModel> users;
  final ErrorModel? error;

  bool isBlocked(int userId) => users.any((u) => u.id == userId);

  BlocksState copyWith({
    BlocksStatus? status,
    List<UserModel>? users,
    ErrorModel? error,
  }) =>
      BlocksState(
        status: status ?? this.status,
        users: users ?? this.users,
        error: error,
      );

  @override
  List<Object?> get props => [status, users, error];
}

/// Кого заблокировал текущий пользователь. Живёт глобально: по списку экраны
/// решают, рисовать «Заблокировать» или «Разблокировать» и гасить ли «Написать».
class BlocksCubit extends Cubit<BlocksState> {
  BlocksCubit(this.authBloc) : super(const BlocksState()) {
    _listenAuth(authBloc.state);
    _authSub = authBloc.stream.listen(_listenAuth);
  }

  final AuthBloc authBloc;
  final SafetyRepository _repository = SafetyRepository();
  StreamSubscription<AuthState>? _authSub;

  void _listenAuth(AuthState state) {
    if (state is AuthLoginState) {
      fetch();
    } else if (state is AuthInitial || state is AuthLogoutState) {
      emit(const BlocksState());
    }
  }

  Future<void> fetch() async {
    if (authBloc.state is! AuthLoginState) return;
    emit(state.copyWith(status: BlocksStatus.loading));
    try {
      final users = await _repository.blocked();
      emit(state.copyWith(status: BlocksStatus.success, users: users));
    } on Object catch (error) {
      emit(state.copyWith(status: BlocksStatus.error, error: _parse(error)));
    }
  }

  /// Бросает дальше: вызывающий показывает снекбар с текстом ошибки.
  Future<void> block(UserModel user) async {
    await _repository.block(user.id);
    if (!state.isBlocked(user.id)) {
      emit(state.copyWith(users: [user, ...state.users]));
    }
  }

  Future<void> unblock(int userId) async {
    await _repository.unblock(userId);
    emit(state.copyWith(
        users: state.users.where((u) => u.id != userId).toList()));
  }

  static ErrorModel _parse(Object error) =>
      error is DioException ? ErrorModel.parseDio(error) : ErrorModel.nothing;

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
