class CategoryModel {
  CategoryModel(this.id, this.name);
  final int id;
  final String name;

  static CategoryModel fromJson(Map<String, dynamic> data) =>
      CategoryModel(data['id'] as int, data['name'] as String);
}
