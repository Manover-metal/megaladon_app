part of 'change_store_form_cubit.dart';

class ChangeStoreFormState extends Equatable {

  final bool status;
  final NameFormModel name;
  final CityFormModel city;
  final StoreTypeFormModel type;
  final BinFormModel bin;
  final LatFormModel lat;
  final LonFormModel lon;
  final MultiContactFormModel contacts;
  final int countTry;

  const ChangeStoreFormState({
    this.status = false,
    this.name = const NameFormModel.pure(),
    this.city = const CityFormModel.pure(),
    this.type = const StoreTypeFormModel.pure(),
    this.bin = const BinFormModel.pure(),
    this.lat = const LatFormModel.pure(),
    this.lon = const LonFormModel.pure(),
    this.contacts = const MultiContactFormModel.pure(),
    this.countTry = 0
  });

  @override
  List<Object?> get props => [status, name, city, type, bin, lat, lon, contacts, countTry];

  ChangeStoreFormState copyWith ({
    bool? status,
    NameFormModel? name,
    CityFormModel? city,
    StoreTypeFormModel? type,
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
      type: type ?? this.type,
      bin: bin ?? this.bin,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      contacts: contacts ?? this.contacts,
      countTry: countTry ?? this.countTry,
    );
  }
}
