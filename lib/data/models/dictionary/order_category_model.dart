class OrderCategoryModel {
  OrderCategoryModel({required this.id, required this.name});
  final int id;
  final String name;

  static OrderCategoryModel fromJson(data) {
    try {
      return OrderCategoryModel(
        id: data['id'] as int,
        name: data['title'] as String,
      );
    } catch (e) {
      return OrderCategoryModel.nothing;
    }
  }

  static List<OrderCategoryModel> listFromJson(List<dynamic> data) => data
      .map<OrderCategoryModel>(
          (item) => OrderCategoryModel.fromJson(item as Map<String, dynamic>))
      .toList();

  static OrderCategoryModel get nothing => OrderCategoryModel(id: -1, name: '');
}
