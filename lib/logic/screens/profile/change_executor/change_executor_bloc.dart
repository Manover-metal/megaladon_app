
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/data/models/request/params/update/change_executor_request_params.dart';
import 'package:megaladon/data/repositories/auth/register_repository.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';

part 'change_executor_event.dart';
part 'change_executor_state.dart';

class ChangeExecutorBloc extends Bloc<ChangeExecutorEvent, ChangeExecutorState> {
  final ProfileScreenCubit profileCubit;
  final UserRepository _repository = UserRepository();
  ChangeExecutorBloc(this.profileCubit) : super(ChangeExecutorInitial()) {
    on<ChangeExecutorFetchEvent>(_register);
  }

  _register(ChangeExecutorFetchEvent event, Emitter emit ) async {
    if(state is ChangeExecutorLoading) return;
    emit(ChangeExecutorLoading());
    await _repository.changeExecutor(event.params).then((value) {
      profileCubit.updateData(profileCubit.state.user!.id);
      emit(ChangeExecutorSuccess());
    }).catchError((error) {
      if(error is DioError) {
        emit(ChangeExecutorError(ErrorModel.parseDio(error)));
      } else {
        emit(ChangeExecutorError(ErrorModel.nothing));
      }
    });
  }
}
