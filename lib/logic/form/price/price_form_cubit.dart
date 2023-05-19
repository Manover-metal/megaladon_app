import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/price_controller.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';

part 'price_form_state.dart';

class PriceFormCubit extends Cubit<PriceFormState> {
  final PriceController _repository = PriceController();
  final ProfileScreenCubit profileCubit;
  final AuthBloc authBloc;

  PriceFormCubit(this.profileCubit, this.authBloc) : super(const PriceFormState()) {
    _checkUpdate();
    profileCubit.stream.listen((stateProfile) {
      _checkUpdate();
    });
  }

  _checkUpdate() {
    if(profileCubit.state.status == ProfileScreenStatus.success && profileCubit.state.store != null) {
      emit(PriceFormState(prices: profileCubit.state.store!.prices));
    }
  }


  addPrice() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']
    );
    if (result != null) {
      final PlatformFile file = result.files[0];
      FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path!, filename: file.name)
      });
      await _repository.addPrice(data).then((value) {
        profileCubit.updateData(profileCubit.state.user!.id);
      }).catchError((error) {
        if(error is DioError) {
          emit(state.copyWith( error: ErrorModel.parseDio(error)));
        } else {
          emit(state.copyWith(error: ErrorModel.nothing));
        }
      });
    }
  }


  deactivate(int id) async {
    _repository.deactivatePrice(id).then((value) {
      profileCubit.updateData(profileCubit.state.user!.id);
    }).catchError((error) {
      if(error is DioError) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }

  delete(int id) async {
    _repository.delete(id).then((value) {
      profileCubit.updateData(profileCubit.state.user!.id);
    }).catchError((error) {
      if(error is DioError) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }

  activate(int id) async {
    _repository.activatePrice(id).then((value) {
      profileCubit.updateData(profileCubit.state.user!.id);
    }).catchError((error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        }
        emit(state.copyWith( error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }
}
