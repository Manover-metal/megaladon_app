class StoreModel {
  final int id;
  final String name;

  StoreModel({
    required this.id,
    required this.name
  });

  static StoreModel fromJson(data) {
    print(data);
    return StoreModel(
        id: data['id'],
        name: data['name'],
    );
  }

  static List<StoreModel> listFromJson(List data) {
    return data.map<StoreModel>((advert) {
      return StoreModel.fromJson(advert);
    }).toList();
  }
}