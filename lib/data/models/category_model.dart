class CategoryModel {
  final int id;
  final String name;

  CategoryModel(this.id, this.name);

  static fromJson(data) {
    return CategoryModel(
      data['id'],
      data['name']
    );
  }
}