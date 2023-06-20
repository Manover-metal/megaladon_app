part of 'change_store_form_cubit.dart';

class ChangeStoreFormState extends Equatable {

  final FormzStatus status;
  final NameFormModel name;
  final CityFormModel city;
  final BinFormModel bin;
  final LatFormModel lat;
  final LonFormModel lon;
  final MultiContactFormModel contacts;
  final int countTry;

  const ChangeStoreFormState({
    this.status = FormzStatus.pure,
    this.name = const NameFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.bin = const BinFormModel.pure(),
    this.lat = const LatFormModel.pure(),
    this.lon = const LonFormModel.pure(),
    this.contacts = const MultiContactFormModel.pure(),
    this.countTry = 0
  });

  @override
  List<Object?> get props => [status, name, city, bin, lat, lon, contacts, countTry];

  ChangeStoreFormState copyWith ({
    FormzStatus? status,
    NameFormModel? name,
    CityFormModel? city,
    BinFormModel? bin,
    LatFormModel? lat,
    LonFormModel? lon,
    MultiContactFormModel? contacts,
    int? countTry
  }) {
    return ChangeStoreFormState(
      status: status ?? this.status,
      name: name ?? this.name,
      city: city ?? this.city,
      bin: bin ?? this.bin,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      contacts: contacts ?? this.contacts,
      countTry: countTry ?? this.countTry,
    );
  }
}
