import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/request/params/index/store_index_request_params.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/repositories/store_repository.dart';

part 'store_screen_main_state.dart';

class StoreScreenMainCubit extends Cubit<StoreScreenMainState> {
  final StoreRepository _repository = StoreRepository();
  StoreScreenMainCubit() : super(const StoreScreenMainState());

  Future fetch({StoreIndexRequestParams? params}) async {
    if(state.status == StoreScreenMainStatus.loading
        && state.error == null
    ) return;

    StoreIndexRequestParams mainParams = params ?? state.params;
    emit(state.copyWith(
        status: StoreScreenMainStatus.loading,
        error: null,
        stores: state.stores,
      )
    );
    return await _repository.index(mainParams).then((value) {
      if(mainParams.startRow == 0) {
        emit(state.copyWith(
            stores: value,
            params: mainParams,
            status: StoreScreenMainStatus.success,
            stock: value.length < mainParams.rowsPerPage
          )
        );
      } else {
        emit(state.copyWith(
          status: StoreScreenMainStatus.success,
          stores: [...state.stores, ...value],
          params: mainParams,
          stock: value.length < mainParams.rowsPerPage
        ));
      }
    }).catchError(( error) {
      if(error is DioError) {
        emit(state.copyWith(
            status: StoreScreenMainStatus.error,
            error: ErrorModel.parseDio(error))
        );
      } else {
        emit(state.copyWith(
            status: StoreScreenMainStatus.error,
            error: ErrorModel.nothing)
        );
      }
    });
  }


  changeParams(StoreIndexRequestParams params) {
    emit(state.copyWith(
        params: params.copyWith(startRow: 0)
    ));
  }
}
