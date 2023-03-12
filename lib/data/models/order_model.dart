import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/user_model.dart';

class OrderModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final int countOffers;


  final String? priceRecommended;
  final String? priceMax;
  final UserModel? user;
  final OrderCategoryModel? category;
  final ExecutorModel? executor;
  final CityModel? city;
  final List? files;

  const OrderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.countOffers,
    this.priceRecommended,
    this.priceMax,
    this.user,
    this.executor,
    this.files,
    this.category,
    this.city
  });

  static OrderModel fromJsonMini(data) {
    return OrderModel(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        priceRecommended: data['price_recommended'],
        priceMax: data['price_max'],
        status: data['status'],
        createdAt: data['created_at'],
        countOffers: data['count_offers'],
        user: data['user'] != null? UserModel.fromJson(data['user']): null,
    );
  }

  static OrderModel fromJsonFull(data) {
    return OrderModel(
      id: data['id'],
      title: data['title'],//
      description: data['description'],//
      priceRecommended: data['price_recommended'],//
      priceMax: data['price_max'],//
      status: data['status'],//
      createdAt: data['created_at'],//
      countOffers: data['count_offers'],
      user: data['user'] != null? UserModel.fromJson(data['user']): null,
      executor: data['executor'] != null? ExecutorModel.fromJson(data['executor']): null,
      files: data['files'],
      category: data['category'] != null? OrderCategoryModel.fromJson(data['category']): null,
      city: data['city'] != null ? CityModel.fromJson(data['city']): null
    );
  }

  static List<OrderModel> listFromJsonMini(List data) {
    return data.map<OrderModel>((advert) {
      return OrderModel.fromJsonMini(advert);
    }).toList();
  }

  @override
  List<Object?> get props => [title, description, priceRecommended, priceMax];
}