import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit(this.authBloc, {UserRepository? repository})
      : _repository = repository ?? UserRepository(),
        super(const DeleteAccountState());

  final AuthBloc authBloc;
  final UserRepository _repository;

  Future<void> deleteAccount(String password) async {
    if (state.status == DeleteAccountStatus.loading) return;

    emit(state.copyWith(status: DeleteAccountStatus.loading));
    await _repository.deleteAccount(password).then((value) {
      emit(state.copyWith(status: DeleteAccountStatus.success));
    }).catchError((Object error) {
      if (error is DioException) {
        emit(state.copyWith(
          error: ErrorModel.parseDio(error),
          status: DeleteAccountStatus.error,
        ));
      } else {
        emit(state.copyWith(
          error: ErrorModel.nothing,
          status: DeleteAccountStatus.error,
        ));
      }
    });
  }
}
