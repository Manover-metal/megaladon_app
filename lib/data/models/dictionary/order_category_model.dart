
class OrderCategoryModel {
  final int id;
  final String name;

  OrderCategoryModel({required this.id, required this.name});

  static OrderCategoryModel fromJson(data) {
    return OrderCategoryModel(
      id: data['id'],
      name: data['name'],
    );
  }

  static List<OrderCategoryModel> listFromJson(data) {
    return data.map<OrderCategoryModel>((city) => OrderCategoryModel.fromJson(city)).toList();
  }
}