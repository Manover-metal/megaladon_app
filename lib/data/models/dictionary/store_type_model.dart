
class StoreTypeModel {
  final int id;
  final String name;

  StoreTypeModel({required this.id, required this.name});

  static StoreTypeModel fromJson(data) {
    try {
      return StoreTypeModel(
        id: data['id'],
        name: data['name'],
      );
    } catch(e) {
      return StoreTypeModel.nothing;
    }
  }

  static List<StoreTypeModel> listFromJson(data) {
    return data.map<StoreTypeModel>((city) => StoreTypeModel.fromJson(city)).toList();
  }

  static StoreTypeModel get nothing => StoreTypeModel(id: -1, name: '');

}