/// Категория из дерева: услуги (заказы, исполнители, объявления-услуги) или
/// объявления. Выбрать можно только конечную — без [children].
class CategoryModel {
  CategoryModel(
      {required this.id, required this.name, this.children = const []});

  final int id;
  final String name;
  final List<CategoryModel> children;

  bool get isLeaf => children.isEmpty;

  /// Бэкенд отдаёт название в title (дерево) или name (объявление, исполнитель).
  static CategoryModel fromJson(Map<String, dynamic> data) => CategoryModel(
        id: data['id'] as int? ?? nothing.id,
        name: (data['title'] ?? data['name'] ?? '') as String,
        children: data['child'] is List
            ? listFromJson(data['child'] as List<dynamic>)
            : const [],
      );

  static List<CategoryModel> listFromJson(List<dynamic> data) => data
      .map<CategoryModel>(
          (item) => CategoryModel.fromJson(item as Map<String, dynamic>))
      .toList();

  static CategoryModel get nothing => CategoryModel(id: -1, name: '');

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
