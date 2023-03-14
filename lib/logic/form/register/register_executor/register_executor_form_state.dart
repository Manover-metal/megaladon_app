part of 'register_executor_form_cubit.dart';

class RegisterExecutorFormState extends Equatable {
  final FormzStatus status;
  final NameFormModel name;
  final CityFormModel city;
  final BinFormModel bin;
  final LatFormModel lat;
  final LonFormModel lon;
  final int countTry;

  const RegisterExecutorFormState({
    this.status = FormzStatus.pure,
    this.name = const NameFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.bin = const BinFormModel.pure(),
    this.lat = const LatFormModel.pure(),
    this.lon = const LonFormModel.pure(),
    this.countTry = 0
  });

  @override
  List<Object?> get props => [status, name, city, bin, lat, lon, countTry];

  RegisterExecutorFormState copyWith ({
    FormzStatus? status,
    NameFormModel? name,
    CityFormModel? city,
    BinFormModel? bin,
    LatFormModel? lat,
    LonFormModel? lon,
    int? countTry
  }) {
    return RegisterExecutorFormState(
        status: status ?? this.status,
        name: name ?? this.name,
        city: city ?? this.city,
        bin: bin ?? this.bin,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        countTry: countTry ?? this.countTry,
    );
  }
}

