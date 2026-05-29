class AdvertCategoryModel {
  AdvertCategoryModel({required this.id, required this.name});
  final int id;
  final String name;

  static AdvertCategoryModel fromJson(data) {
    try {
      return AdvertCategoryModel(
        id: data['id'] as int,
        name: data['title'] as String,
      );
    } catch (e) {
      return AdvertCategoryModel.nothing;
    }
  }

  static List<AdvertCategoryModel> listFromJson(data) => (data as List)
      .map<AdvertCategoryModel>(
          (item) => AdvertCategoryModel.fromJson(item as Map<String, dynamic>))
      .toList();

  static AdvertCategoryModel get nothing =>
      AdvertCategoryModel(id: -1, name: '');
}
