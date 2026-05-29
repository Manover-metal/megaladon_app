part of 'change_password_cubit.dart';

enum ChangePasswordStatus { initial, loading, success, error }

class ChangePasswordState extends Equatable {
  const ChangePasswordState(
      {this.status = ChangePasswordStatus.initial, this.error});
  final ChangePasswordStatus status;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, error];
}
