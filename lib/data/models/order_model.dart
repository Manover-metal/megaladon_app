import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final int price;
  final int categoryId;
  final String additionalPhone;

  const OrderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.additionalPhone
  });

  static OrderModel fromJson(data) {
    return OrderModel(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        price: data['price'],
        categoryId: data['category_id'],
        additionalPhone: data['additional_phone']
    );
  }

  static List<OrderModel> listFromJson(List data) {
    return data.map<OrderModel>((advert) {
      return OrderModel.fromJson(advert);
    }).toList();
  }

  @override
  List<Object?> get props => [title, description, price, categoryId, additionalPhone];
}