import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/repositories/executor_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'executor_screen_my_state.dart';

class ExecutorScreenMyCubit extends Cubit<ExecutorScreenMyState> {
  final ExecutorRepository _repository = ExecutorRepository();
  final AuthBloc authBloc;
  ExecutorScreenMyCubit(this.authBloc) : super(const ExecutorScreenMyState()) {
    _listenAuth(authBloc.state);
    authBloc.stream.listen(_listenAuth);
  }

  _listenAuth(stateAuth) {
    if(stateAuth is AuthLoginState) {
      fetch();
    } else {
      emit(const ExecutorScreenMyState());
    }
  }

  Future fetch() async {
    if(state.status == ExecutorScreenMyStatus.loading
        && state.error == null
    ) return;

    emit(state.copyWith(
        status: ExecutorScreenMyStatus.loading,
        error: null,
        executors: state.executors,

      )
    );

    return await _repository.my().then((value) {
      emit(state.copyWith(
          status: ExecutorScreenMyStatus.success,
          executors: [...state.executors, ...value],
      ));
    }).catchError((error) {
      print(error);
      if(error is DioError) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }

  Future add({
    required int orderId,
    required int executorId
  }) async {
    return await _repository.addFavorite(orderId, executorId).then((value) {
      fetch();
    }).catchError((error) {
      if(error is DioError) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }
}