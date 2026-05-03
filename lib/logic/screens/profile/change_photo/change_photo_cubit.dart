import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:megaladon/core/image/image_service.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';

part 'change_photo_state.dart';

class ChangePhotoCubit extends Cubit<ChangePhotoState> {
  final UserRepository _repository = UserRepository();
  final ProfileScreenCubit profileCubit;
  final AuthBloc authBloc;
  ChangePhotoCubit(this.profileCubit, this.authBloc) : super(const ChangePhotoState()) {
    _listenProfile(profileCubit.state);
    profileCubit.stream.listen(_listenProfile);
  }


  changePhoto() async {
    final result = await ImageService.getImage();
    if(result == null) return;

    PlatformFile file = result.files[0];

    emit(ChangePhotoState(imageData: file.bytes, status: PhotoStatus.bytes));


    FormData data = FormData.fromMap({
      'photo': await MultipartFile.fromFile(file.path!, filename: file.name)
    });
    _repository.changePhoto(data).catchError((error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        }
        emit(ChangePhotoState(status: PhotoStatus.error, error: ErrorModel.parseDio(error)));
      } else {
        emit(ChangePhotoState(status: PhotoStatus.error, error: ErrorModel.nothing));
      }
    });
  }

  _listenProfile(ProfileScreenState profileState) {
    if(profileState.status == ProfileScreenStatus.success) {
      String? url = profileState.user?.photo;
      emit(ChangePhotoState(
          url: url,
          status: url != null? PhotoStatus.url : PhotoStatus.none
      ));
    }
  }
}
