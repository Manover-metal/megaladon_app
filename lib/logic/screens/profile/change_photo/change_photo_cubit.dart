import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:megaladon/core/image/image_service.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';

part 'change_photo_state.dart';

class ChangePhotoCubit extends Cubit<ChangePhotoState> {
  ChangePhotoCubit(this.profileCubit, this.authBloc)
      : super(const ChangePhotoState()) {
    _listenProfile(profileCubit.state);
    profileCubit.stream.listen(_listenProfile);
  }
  final UserRepository _repository = UserRepository();
  final ProfileScreenCubit profileCubit;
  final AuthBloc authBloc;

  Future<void> changePhoto() async {
    final result = await ImageService.getImage();
    if (result == null) {
      log('changePhoto: выбор изображения отменён', name: 'ChangePhoto');
      return;
    }

    final file = result.files[0];

    // На некоторых платформах path может быть null (только bytes) — тогда
    // MultipartFile.fromFile падал бы и запрос вообще не уходил (без логов).
    if (file.path == null) {
      log('changePhoto: у выбранного файла нет path', name: 'ChangePhoto');
      emit(const ChangePhotoState(status: PhotoStatus.error, error: null));
      return;
    }

    emit(ChangePhotoState(imageData: file.bytes, status: PhotoStatus.bytes));

    try {
      final data = FormData.fromMap({
        'photo': await MultipartFile.fromFile(file.path!, filename: file.name),
      });
      log('changePhoto: отправка ${file.name} (${file.size} байт)',
          name: 'ChangePhoto');
      await _repository.changePhoto(data);
      log('changePhoto: успех, обновляю профиль', name: 'ChangePhoto');
      // Перечитываем профиль, чтобы новое фото отразилось в UI: после fetch()
      // _listenProfile получит свежий photo и переключит состояние на url.
      await profileCubit.fetch();
    } on DioException catch (error) {
      log('changePhoto: DioException ${error.response?.statusCode} ${error.message}',
          name: 'ChangePhoto', error: error);
      if (error.response?.statusCode == 403) {
        authBloc.add(AuthLogoutEvent());
      }
      emit(ChangePhotoState(
          status: PhotoStatus.error, error: ErrorModel.parseDio(error)));
    } catch (e, st) {
      log('changePhoto: непредвиденная ошибка $e',
          name: 'ChangePhoto', error: e, stackTrace: st);
      emit(ChangePhotoState(
          status: PhotoStatus.error, error: ErrorModel.nothing));
    }
  }

  void _listenProfile(ProfileScreenState profileState) {
    if (profileState.status == ProfileScreenStatus.success) {
      var url = profileState.user?.photo;
      emit(ChangePhotoState(
          url: url, status: url != null ? PhotoStatus.url : PhotoStatus.none));
    }
  }
}
