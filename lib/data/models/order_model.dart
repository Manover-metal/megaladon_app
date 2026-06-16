import 'package:equatable/equatable.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/user_model.dart';

enum OrderStatus { nothing, moderate, active, hasExecutor, completed, archive }

class OrderModel extends Equatable {
  const OrderModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.statusName,
      required this.createdAt,
      required this.countOffers,
      this.priceRecommended,
      this.priceMax,
      this.user,
      this.executor,
      this.files = const [],
      this.images = const [],
      this.category,
      this.city,
      this.status = OrderStatus.nothing});
  final int id;
  final String title;
  final String description;
  final String statusName;
  final String createdAt;
  final int countOffers;

  final String? priceRecommended;
  final String? priceMax;
  final UserModel? user;
  final OrderCategoryModel? category;
  final ExecutorModel? executor;
  final CityModel? city;
  final List<FileModel> files;
  final List<FileModel> images;

  final OrderStatus status;

  static OrderModel fromJsonMini(Map<String, dynamic> data) => OrderModel(
        id: data['id'] as int,
        title: data['title'] as String,
        description: data['description'] as String,
        priceRecommended: data['price_recommended'] != null
            ? Parser.toPrice(data['price_recommended'])
            : null,
        priceMax: data['price_max'] != null
            ? Parser.toPrice(data['price_max'])
            : null,
        statusName: data['status'] as String,
        createdAt: data['created_at'] as String,
        countOffers: data['count_offers'] as int,
        user: data['user'] != null
            ? UserModel.fromJson(data['user'] as Map<String, dynamic>)
            : null,
      );

  static OrderModel fromJsonFull(Map<String, dynamic> data) {
    var files = data['files'] != null
        ? FileModel.listFromJson(data['files'] as List<dynamic>)
        : null;
    var imageFiles = <FileModel>[];
    var otherFiles = <FileModel>[];

    if (files != null) {
      imageFiles = files
          .where((file) =>
              file.url.endsWith('.jpg') ||
              file.url.endsWith('.jpeg') ||
              file.url.endsWith('.png'))
          .toList();
      otherFiles = files
          .where((file) =>
              !file.url.endsWith('.jpg') &&
              !file.url.endsWith('.jpeg') &&
              !file.url.endsWith('.png'))
          .toList();
    }

    print('EEXECUTOR: $data');

    return OrderModel(
      id: data['id'] as int,
      title: data['title'] as String,
      description: data['description'] as String,
      priceRecommended: data['price_recommended'] != null
          ? Parser.toPrice(data['price_recommended'])
          : null,
      priceMax:
          data['price_max'] != null ? Parser.toPrice(data['price_max']) : null,
      statusName: data['status'] as String,
      createdAt: data['created_at'] as String,
      countOffers: data['count_offers'] as int,
      files: otherFiles,
      images: imageFiles,
      user: data['user'] != null
          ? UserModel.fromJson(data['user'] as Map<String, dynamic>)
          : null,
      executor: data['executor'] != null
          ? ExecutorModel.fromJson(data['executor'] as Map<String, dynamic>)
          : null,
      category: data['category'] != null
          ? OrderCategoryModel.fromJson(
              data['category'] as Map<String, dynamic>)
          : null,
      city: data['city'] != null
          ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
          : null,
      status: data['status_code'] != null
          ? OrderStatus.values[Parser.toInt(data['status_code'])]
          : OrderStatus.nothing,
    );
  }

  static List<OrderModel> listFromJsonMini(List<dynamic> data) => data
      .map<OrderModel>(
          (item) => OrderModel.fromJsonMini(item as Map<String, dynamic>))
      .toList();

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        statusName,
        createdAt,
        countOffers,
        priceRecommended,
        priceMax,
        user,
        executor,
        files,
        category,
        city,
        status
      ];
}
