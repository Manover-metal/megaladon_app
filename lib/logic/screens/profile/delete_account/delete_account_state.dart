part of 'delete_account_cubit.dart';

enum DeleteAccountStatus { initial, loading, success, error }

class DeleteAccountState extends Equatable {
  const DeleteAccountState({
    this.status = DeleteAccountStatus.initial,
    this.error,
  });

  final DeleteAccountStatus status;
  final ErrorModel? error;

  @override
  List<Object?> get props => [status, error];

  DeleteAccountState copyWith({
    DeleteAccountStatus? status,
    ErrorModel? error,
  }) =>
      DeleteAccountState(
        status: status ?? this.status,
        error: error ?? this.error,
      );
}
