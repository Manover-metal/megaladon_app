part of 'change_executor_form_cubit.dart';

class ChangeExecutorFormState extends Equatable {
  const ChangeExecutorFormState(
      {this.status = false,
      this.name = const NameFormModel.pure(),
      this.city = const CityFormModel.pure(),
      this.services = const MultiServiceTypeFormModel.pure(),
      this.countTry = 0});
  final bool status;
  final NameFormModel name;
  final CityFormModel city;
  final MultiServiceTypeFormModel services;
  final int countTry;

  @override
  List<Object?> get props => [status, name, city, services, countTry];

  ChangeExecutorFormState copyWith(
          {bool? status,
          NameFormModel? name,
          CityFormModel? city,
          MultiServiceTypeFormModel? services,
          int? countTry}) =>
      ChangeExecutorFormState(
          status: status ?? this.status,
          name: name ?? this.name,
          city: city ?? this.city,
          services: services ?? this.services,
          countTry: countTry ?? this.countTry);
}
