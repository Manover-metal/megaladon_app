
class AddressServiceModel {
  final int id;
  final String? name;

  AddressServiceModel({required this.id, this.name});

  static AddressServiceModel fromJson(data) {
    return AddressServiceModel(
      id: data['id'],
      name: data['name'],
    );
  }
}