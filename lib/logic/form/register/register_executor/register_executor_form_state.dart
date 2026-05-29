part of 'register_executor_form_cubit.dart';

class RegisterExecutorFormState extends Equatable {
  const RegisterExecutorFormState(
      {this.status = false,
      this.name = const NameFormModel.pure(),
      this.city = const CityFormModel.pure(),
      this.description = const DescriptionFormModel.pure(),
      this.bin = const BinFormModel.pure(),
      this.lat = const LatFormModel.pure(),
      this.lon = const LonFormModel.pure(),
      this.services = const MultiServiceTypeFormModel.pure(),
      this.countTry = 0});
  final bool status;
  final NameFormModel name;
  final CityFormModel city;
  final DescriptionFormModel description;
  final BinFormModel bin;
  final LatFormModel lat;
  final LonFormModel lon;
  final MultiServiceTypeFormModel services;
  final int countTry;

  @override
  List<Object?> get props =>
      [status, name, city, bin, lat, lon, services, countTry, description];

  RegisterExecutorFormState copyWith(
          {bool? status,
          NameFormModel? name,
          CityFormModel? city,
          BinFormModel? bin,
          LatFormModel? lat,
          LonFormModel? lon,
          MultiServiceTypeFormModel? services,
          int? countTry}) =>
      RegisterExecutorFormState(
        status: status ?? this.status,
        name: name ?? this.name,
        city: city ?? this.city,
        bin: bin ?? this.bin,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        services: services ?? this.services,
        countTry: countTry ?? this.countTry,
      );
}
