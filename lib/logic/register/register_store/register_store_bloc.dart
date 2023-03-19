
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
  final RegisterRepository _repository = RegisterRepository();
  RegisterStoreBloc() : super(RegisterStoreInitial()) {
    on<RegisterStoreFetchEvent>(_register);
  }

  _register(RegisterStoreFetchEvent event, Emitter emit ) async {
    emit(RegisterStoreLoading());
    await _repository.registerStore(event.params).then((value) {
      final StoreModel store = StoreModel.fromJsonMini(value.data['store']);
      emit(RegisterStoreSuccess(store));
    }).catchError((error) {
      if(error is DioError) {
        emit(RegisterStoreError(ErrorModel.parseDio(error)));
      } else {
        emit(RegisterStoreError(ErrorModel.nothing));
      }
    });
  }
}
