
class StoreTypeModel {
  final int id;
  final String name;

  StoreTypeModel({required this.id, required this.name});

  static StoreTypeModel fromJson(data) {
    return StoreTypeModel(
      id: data['id'],
      name: data['name'],
    );
  }

  static List<StoreTypeModel> listFromJson(data) {
    return data.map<StoreTypeModel>((city) => StoreTypeModel.fromJson(city)).toList();
  }
}