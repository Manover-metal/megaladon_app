class AdvertCategoryModel {
  AdvertCategoryModel({required this.id, required this.name});
  final int id;
  final String name;

  static AdvertCategoryModel fromJson(Map<String, dynamic> data) {
    late final String name;

    if (data['title'] is String) {
      name = data['title'] as String;
    } else if (data['name'] is String) {
      name = data['name'] as String;
    }

    return AdvertCategoryModel(
      id: data['id'] as int,
      name: name,
    );
  }

  static List<AdvertCategoryModel> listFromJson(List<dynamic> data) => data
      .map<AdvertCategoryModel>(
          (item) => AdvertCategoryModel.fromJson(item as Map<String, dynamic>))
      .toList();

  static AdvertCategoryModel get nothing =>
      AdvertCategoryModel(id: -1, name: '');
}
