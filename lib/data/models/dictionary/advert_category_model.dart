
class AdvertCategoryModel {
  final int id;
  final String name;

  AdvertCategoryModel({required this.id, required this.name});

  static AdvertCategoryModel fromJson(data) {
    return AdvertCategoryModel(
      id: data['id'],
      name: data['name'],
    );
  }

  static List<AdvertCategoryModel> listFromJson(data) {
    return data.map<AdvertCategoryModel>((city) => AdvertCategoryModel.fromJson(city)).toList();
  }
}