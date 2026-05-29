import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/register/register_store_request_params.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/auth/register_repository.dart';

part 'register_store_event.dart';
part 'register_store_state.dart';

class RegisterStoreBloc extends Bloc<RegisterStoreEvent, RegisterStoreState> {
  RegisterStoreBloc() : super(RegisterStoreInitial()) {
    on<RegisterStoreFetchEvent>(_register);
  }
  final RegisterRepository _repository = RegisterRepository();

  Future<void> _register(
      RegisterStoreFetchEvent event, Emitter<void> emit) async {
    if (state is RegisterStoreLoading) return;

    emit(RegisterStoreLoading());
    await _repository.registerStore(event.params).then((store) {
      emit(RegisterStoreSuccess(store));
    }).catchError((Object error) {
      if (error is DioException) {
        emit(RegisterStoreError(ErrorModel.parseDio(error)));
      } else {
        emit(RegisterStoreError(ErrorModel.nothing));
      }
    });
  }
}
