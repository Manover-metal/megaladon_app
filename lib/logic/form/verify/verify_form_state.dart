part of 'verify_form_cubit.dart';

class VerifyFormState extends Equatable {
  const VerifyFormState(
      {this.pincode = const PincodeFormModel.pure(),
      this.status = false,
      this.countTry = 0});
  final PincodeFormModel pincode;
  final bool status;
  final int countTry;

  @override
  List<Object?> get props => [pincode, status, countTry];

  VerifyFormState copyWith(
          {bool? status, PincodeFormModel? pincode, int? countTry}) =>
      VerifyFormState(
          status: status ?? this.status,
          countTry: countTry ?? this.countTry,
          pincode: pincode ?? this.pincode);
}
