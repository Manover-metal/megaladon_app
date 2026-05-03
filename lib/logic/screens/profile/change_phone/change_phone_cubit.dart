import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/models/form/password.dart';
import 'package:megaladon/data/models/form/phone.dart';
import 'package:megaladon/data/models/form/pincode.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';

part 'change_phone_state.dart';

class ChangePhoneCubit extends Cubit<ChangePhoneState> {
  final ProfileScreenCubit profileCubit;
  final UserRepository _repository = UserRepository();
  ChangePhoneCubit(this.profileCubit) : super(const ChangePhoneState());


  bool checkStep1({
    required String phone,
    required String password,
  }) {
    PhoneFormModel phoneForm = PhoneFormModel.dirty(phone);
    PasswordFormModel passwordForm = PasswordFormModel.dirty(password);

    final status = Formz.validate([
      passwordForm,
      phoneForm
    ]);
    if(!status) {
      if(passwordForm.isNotValid) emit(ChangePhoneState(error: ErrorModel([passwordForm.error.toString()]), status: ChangePhoneStatus.error));
      if(phoneForm.isNotValid) emit(ChangePhoneState(error: ErrorModel([phoneForm.error.toString()]), status: ChangePhoneStatus.error));
    }

    return status;
  }


  bool checkStep2({
    required String phone,
    required String code,
  }) {
    PhoneFormModel phoneForm = PhoneFormModel.dirty(phone);
    PincodeFormModel pincodeForm = PincodeFormModel.dirty(code);

    final status = Formz.validate([
      pincodeForm,
      phoneForm
    ]);
    if(!status) {
      if(pincodeForm.isNotValid) emit(ChangePhoneState(error: ErrorModel([pincodeForm.error.toString()]), status: ChangePhoneStatus.error));
      if(phoneForm.isNotValid) emit(ChangePhoneState(error: ErrorModel([phoneForm.error.toString()]), status: ChangePhoneStatus.error));
    }

    return status;
  }

  changePhoneStart({
    required String phone,
    required String password,
  }) async {
    if(state.status == ChangePhoneStatus.loading) return;

    emit(const ChangePhoneState(status: ChangePhoneStatus.loading));
    await _repository.changePhoneStepStart(
        phone: phone,
        password: password
    ).then((value) {
      emit(const ChangePhoneState(status: ChangePhoneStatus.success));
    }).catchError((error) {
      if(error is DioError) {
        emit(ChangePhoneState(error: ErrorModel.parseDio(error), status: ChangePhoneStatus.error));
      } else {
        emit(ChangePhoneState(error: ErrorModel.nothing, status: ChangePhoneStatus.error));
      }
    });
  }

  changePhoneEnd({
    required String phone,
    required String code,
  }) async {
    if(state.status == ChangePhoneStatus.loading2) return;

    emit(const ChangePhoneState(status: ChangePhoneStatus.loading2));
    await _repository.changePhoneStepEnd(
        phone: phone,
        code: code
    ).then((value) {
      profileCubit.updateData(profileCubit.state.user!.id);
      emit(const ChangePhoneState(status: ChangePhoneStatus.success2));
    }).catchError((error) {
      if(error is DioError) {
        emit(ChangePhoneState(error: ErrorModel.parseDio(error), status: ChangePhoneStatus.error2));
      } else {
        emit(ChangePhoneState(error: ErrorModel.nothing, status: ChangePhoneStatus.error2));
      }
    });
  }
}
