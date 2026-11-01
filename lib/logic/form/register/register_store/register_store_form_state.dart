part of 'register_store_form_cubit.dart';

class RegisterStoreFormState extends Equatable {
  const RegisterStoreFormState(
      {this.status = false,
      this.name = const NameFormModel.pure(),
      this.city = const CityFormModel.pure(),
      this.type = const CompanyTypeFormModel.pure(),
      this.bin = const BinFormModel.pure(),
      this.contacts = const MultiContactFormModel.pure(),
      this.countTry = 0});
  final bool status;
  final NameFormModel name;
  final CityFormModel city;
  final CompanyTypeFormModel type;
  final BinFormModel bin;
  final MultiContactFormModel contacts;
  final int countTry;

  @override
  List<Object?> get props =>
      [status, name, city, type, bin, contacts, countTry];

  RegisterStoreFormState copyWith(
          {bool? status,
          NameFormModel? name,
          CityFormModel? city,
          CompanyTypeFormModel? type,
          BinFormModel? bin,
          MultiContactFormModel? contacts,
          int? countTry}) =>
      RegisterStoreFormState(
        status: status ?? this.status,
        name: name ?? this.name,
        city: city ?? this.city,
        type: type ?? this.type,
        bin: bin ?? this.bin,
        contacts: contacts ?? this.contacts,
        countTry: countTry ?? this.countTry,
      );
}
