class AddressServiceModel {
  AddressServiceModel({required this.id, this.name});
  final int id;
  final String? name;

  static AddressServiceModel fromJson(data) => AddressServiceModel(
        id: data['id'] as int,
        name: data['name'] as String?,
      );
}
