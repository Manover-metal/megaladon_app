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
    if (result == null) return;

    var file = result.files[0];

    emit(ChangePhotoState(imageData: file.bytes, status: PhotoStatus.bytes));

    var data = FormData.fromMap({
      'photo': await MultipartFile.fromFile(file.path!, filename: file.name)
    });
    _repository.changePhoto(data).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        }
        emit(ChangePhotoState(
            status: PhotoStatus.error, error: ErrorModel.parseDio(error)));
      } else {
        emit(ChangePhotoState(
            status: PhotoStatus.error, error: ErrorModel.nothing));
      }
    });
  }

  void _listenProfile(ProfileScreenState profileState) {
    if (profileState.status == ProfileScreenStatus.success) {
      var url = profileState.user?.photo;
      emit(ChangePhotoState(
          url: url, status: url != null ? PhotoStatus.url : PhotoStatus.none));
    }
  }
}
