
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/register/register_store_request_params.dart';
import 'package:megaladon/data/models/request/params/update/change_store_request_params.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/auth/register_repository.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';

part 'change_store_event.dart';
part 'change_store_state.dart';

class ChangeStoreBloc extends Bloc<ChangeStoreEvent, ChangeStoreState> {
  final ProfileScreenCubit profileCubit;
  final AuthBloc authBloc;
  final UserRepository _repository = UserRepository();
  ChangeStoreBloc(this.profileCubit, this.authBloc) : super(ChangeStoreInitial()) {
    on<ChangeStoreFetchEvent>(_register);
  }

  _register(ChangeStoreFetchEvent event, Emitter emit ) async {
    if(state is ChangeStoreLoading) return;


    emit(ChangeStoreLoading());
    await _repository.changeStore(event.params).then((value) {
      print(value);

      profileCubit.updateData(profileCubit.state.user!.id);
      emit(const ChangeStoreSuccess());
    }).catchError((error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        }
        emit(ChangeStoreError(ErrorModel.parseDio(error)));
      } else {
        emit(ChangeStoreError(ErrorModel.nothing));
      }
    });
  }
}
