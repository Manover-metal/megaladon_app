
class OrderCategoryModel {
  final int id;
  final String name;

  OrderCategoryModel({required this.id, required this.name});

  static OrderCategoryModel fromJson(data) {
    try {
      return OrderCategoryModel(
        id: data['id'],
        name: data['title'],
      );
    } catch(e) {
      return OrderCategoryModel.nothing;
    }
  }

  static List<OrderCategoryModel> listFromJson(data) {
    return data.map<OrderCategoryModel>((city) => OrderCategoryModel.fromJson(city)).toList();
  }

  static OrderCategoryModel get nothing => OrderCategoryModel(id: -1, name: '');
}