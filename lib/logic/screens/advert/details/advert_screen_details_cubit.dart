import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/enum_form_state.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';
import 'package:megaladon/logic/form/update/ad/ad_update_form_cubit.dart';

part 'advert_screen_details_state.dart';

class AdvertScreenDetailsCubit extends Cubit<AdvertScreenDetailsState> {
  AdvertScreenDetailsCubit(this._updateFormCubit)
      : super(AdvertScreenDetailsInitial()) {
    // Связь со страницей редактирования: при успешном обновлении
    // принудительно перезагружаем открытую деталку.
    _updateSub = _updateFormCubit.stream.listen(_onUpdateFormChanged);
  }
  final AdvertRepository _repository = AdvertRepository();
  final AdUpdateFormCubit _updateFormCubit;
  late final StreamSubscription<AdUpdateFormState> _updateSub;

  void _onUpdateFormChanged(AdUpdateFormState formState) {
    if (formState.formState == EnumFormState.success &&
        state is AdvertScreenDetailsSuccess) {
      fetch(
        id: (state as AdvertScreenDetailsSuccess).advert.id,
        force: true,
      );
    }
  }

  Future fetch({required int id, bool force = false}) async {
    if (!force &&
        state is AdvertScreenDetailsSuccess &&
        (state as AdvertScreenDetailsSuccess).advert.id == id) {
      return;
    }
    emit(AdvertScreenDetailsLoader());
    return await _repository.info(id).then((value) {
      emit(AdvertScreenDetailsSuccess(advert: value));
    }).catchError((error, stackTrace) {
      if (error is DioException) {
        emit(AdvertScreenDetailsError(ErrorModel.parseDio(error)));
      } else {
        emit(AdvertScreenDetailsError(ErrorModel.nothing));
      }
    });
  }

  @override
  Future<void> close() {
    _updateSub.cancel();
    return super.close();
  }
}
