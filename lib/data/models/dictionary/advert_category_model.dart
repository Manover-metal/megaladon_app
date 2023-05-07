
class AdvertCategoryModel {
  final int id;
  final String name;

  AdvertCategoryModel({required this.id, required this.name});

  static AdvertCategoryModel fromJson(data) {
    try {
      return AdvertCategoryModel(
        id: data['id'],
        name: data['title'],
      );
    } catch(e) {
      return AdvertCategoryModel.nothing;
    }
  }

  static List<AdvertCategoryModel> listFromJson(data) {
    return data.map<AdvertCategoryModel>((city) => AdvertCategoryModel.fromJson(city)).toList();
  }

  static AdvertCategoryModel get nothing => AdvertCategoryModel(id: -1, name: '');

}