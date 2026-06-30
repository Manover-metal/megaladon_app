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
  PriceFormCubit(this.profileCubit, this.authBloc)
      : super(const PriceFormState()) {
    _checkUpdate();
    profileCubit.stream.listen((stateProfile) {
      _checkUpdate();
    });
  }

  final PriceController _repository = PriceController();
  final ProfileScreenCubit profileCubit;
  final AuthBloc authBloc;

  void _checkUpdate() {
    if (profileCubit.state.status == ProfileScreenStatus.success &&
        profileCubit.state.user?.store != null) {
      emit(PriceFormState(prices: profileCubit.state.user!.store!.prices));
    }
  }

  Future<void> addPrice() async {
    var result = await FilePicker.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      final file = result.files.elementAtOrNull(0);
      if (file == null) return;
      final contentType = DioMediaType('application', 'pdf');
      var data = FormData.fromMap({
        'file': MultipartFile.fromBytes(file.bytes!,
            filename: file.name, contentType: contentType)
      });
      await _repository.addPrice(data).then((value) {
        profileCubit.updateData();
      }).catchError((error) {
        if (error is DioException) {
          emit(state.copyWith(error: ErrorModel.parseDio(error)));
        } else {
          emit(state.copyWith(error: ErrorModel.nothing));
        }
      });
    }
  }

  Future<void> deactivate(int id) async {
    _repository.deactivatePrice(id).then((value) {
      profileCubit.updateData();
    }).catchError((error) {
      if (error is DioException) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }

  Future<void> delete(int id) async {
    _repository.delete(id).then((value) {
      profileCubit.updateData();
    }).catchError((error) {
      if (error is DioException) {
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }

  Future<void> activate(int id) async {
    _repository.activatePrice(id).then((value) {
      profileCubit.updateData();
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 403) {
          authBloc.add(AuthLogoutEvent());
        }
        emit(state.copyWith(error: ErrorModel.parseDio(error)));
      } else {
        emit(state.copyWith(error: ErrorModel.nothing));
      }
    });
  }
}
