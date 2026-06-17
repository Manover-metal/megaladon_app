import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

part 'service_screen_my_state.dart';

class ServiceScreenMyCubit extends Cubit<ServiceScreenMyState> {
  ServiceScreenMyCubit(this.authBloc) : super(const ServiceScreenMyState()) {
    _listenAuth(authBloc.state);
    authBloc.stream.listen(_listenAuth);
  }
  final AdvertRepository _repository = AdvertRepository();
  final AuthBloc authBloc;

  void _listenAuth(stateAuth) {
    if (stateAuth is AuthLoginState) {
      fetch();
    } else {
      emit(const ServiceScreenMyState());
    }
  }

  Future fetch({AdvertIndexRequestParams? params}) async {
    if (state.status == ServiceScreenMyStatus.loading && state.error == null)
      return;

    var mainParams = params ?? state.params;
    emit(state.copyWith(
        status: ServiceScreenMyStatus.loading,
        error: null,
        services: state.services));

    return await _repository
        .indexMy(mainParams, AdvertType.service)
        .then((value) {
      if (mainParams.startRow == 0) {
        emit(state.copyWith(
            services: value,
            params: mainParams,
            status: ServiceScreenMyStatus.success,
            stock: value.length < mainParams.rowsPerPage));
      } else {
        emit(state.copyWith(
            status: ServiceScreenMyStatus.success,
            services: [...state.services, ...value],
            params: mainParams,
            stock: value.length < mainParams.rowsPerPage));
      }
    }).catchError((error) {
      if (error is DioException) {
        emit(state.copyWith(
            status: ServiceScreenMyStatus.error,
            error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(
            status: ServiceScreenMyStatus.error, error: ErrorModel.nothing));
      }
    });
  }

  void changeParams(AdvertIndexRequestParams params) {
    emit(state.copyWith(params: params.copyWith(startRow: 0)));
  }
}
