part of 'change_password_cubit.dart';

enum ChangePasswordStatus {
  initial, loading, success, error
}

class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;
  final ErrorModel? error;


  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.error
  });

  @override
  List<Object?> get props => [status, error];
}
