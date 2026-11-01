part of 'register_executor_form_cubit.dart';

class RegisterExecutorFormState extends Equatable {
  const RegisterExecutorFormState(
      {this.status = false,
      this.name = const NameFormModel.pure(),
      this.bin = const BinFormModel.pure(),
      this.services = const MultiServiceTypeFormModel.pure(),
      this.countTry = 0});
  final bool status;
  final NameFormModel name;
  final BinFormModel bin;
  final MultiServiceTypeFormModel services;
  final int countTry;

  @override
  List<Object?> get props => [status, name, bin, services, countTry];

  RegisterExecutorFormState copyWith(
          {bool? status,
          NameFormModel? name,
          BinFormModel? bin,
          MultiServiceTypeFormModel? services,
          int? countTry}) =>
      RegisterExecutorFormState(
        status: status ?? this.status,
        name: name ?? this.name,
        bin: bin ?? this.bin,
        services: services ?? this.services,
        countTry: countTry ?? this.countTry,
      );
}
