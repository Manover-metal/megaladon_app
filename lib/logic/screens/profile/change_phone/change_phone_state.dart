part of 'change_phone_cubit.dart';

enum ChangePhoneStatus {
  initial,
  loading,
  success,
  error,
  initial2,
  loading2,
  success2,
  error2
}

class ChangePhoneState extends Equatable {
  const ChangePhoneState({this.status = ChangePhoneStatus.initial, this.error});
  final ChangePhoneStatus status;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, error];
}
