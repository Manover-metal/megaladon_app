part of 'change_store_form_cubit.dart';

class ChangeStoreFormState extends Equatable {
  const ChangeStoreFormState(
      {this.status = false,
      this.name = const NameFormModel.pure(),
      this.city = const CityFormModel.pure(),
      this.contacts = const MultiContactFormModel.pure(),
      this.countTry = 0});
  final bool status;
  final NameFormModel name;
  final CityFormModel city;
  final MultiContactFormModel contacts;
  final int countTry;

  @override
  List<Object?> get props => [status, name, city, contacts, countTry];

  ChangeStoreFormState copyWith(
          {bool? status,
          NameFormModel? name,
          CityFormModel? city,
          MultiContactFormModel? contacts,
          int? countTry}) =>
      ChangeStoreFormState(
        status: status ?? this.status,
        name: name ?? this.name,
        city: city ?? this.city,
        contacts: contacts ?? this.contacts,
        countTry: countTry ?? this.countTry,
      );
}
