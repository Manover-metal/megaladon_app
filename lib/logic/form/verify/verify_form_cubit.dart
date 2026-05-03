import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:megaladon/data/models/form/pincode.dart';

part 'verify_form_state.dart';

class VerifyFormCubit extends Cubit<VerifyFormState> {
  VerifyFormCubit() : super(VerifyFormState());

  bool checkForm(String code) {
    PincodeFormModel codeForm = PincodeFormModel.dirty(code);

    bool status = Formz.validate([
      codeForm
    ]);

    VerifyFormState stateNew = state.copyWith(
        pincode: codeForm,
        status: status,
        countTry: state.countTry + 1
    );
    emit(stateNew);
    return stateNew.status;
  }
}
