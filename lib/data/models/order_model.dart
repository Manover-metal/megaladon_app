import 'package:equatable/equatable.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

enum OrderStatus {
  nothing,
  moderate,
  active,
  hasExecutor,
  completed,
  archive;

  String localize(AppLocalizations l10n) {
    switch (this) {
      case OrderStatus.moderate:
        return l10n.moderate;
      case OrderStatus.active:
        return l10n.active;
      case OrderStatus.hasExecutor:
        return l10n.in_work;
      case OrderStatus.completed:
        return l10n.completed;
      case OrderStatus.archive:
        return l10n.archive;
      case OrderStatus.nothing:
        return l10n.all;
    }
  }
}

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
      this.executionDays,
      this.user,
      this.executor,
      this.files = const [],
      this.images = const [],
      this.category,
      this.city,
      this.status = OrderStatus.nothing,
      this.statusChanged = false,
      this.newOffersCount = 0});
  final int id;
  final String title;
  final String description;
  final String statusName;
  final String createdAt;
  final int countOffers;

  final String? priceRecommended;
  final String? priceMax;
  final int? executionDays;
  final UserModel? user;
  final OrderCategoryModel? category;
  final ExecutorModel? executor;
  final CityModel? city;
  final List<FileModel> files;
  final List<FileModel> images;

  final OrderStatus status;

  /// С последнего просмотра у заказа сменился статус. Считает бэкенд по
  /// `order_views`; в общей ленте поля нет — там бейджей не показываем.
  final bool statusChanged;

  /// Сколько откликов прибавилось с последнего просмотра. Осмысленно только
  /// в списке своих заказов.
  final int newOffersCount;

  /// Заказ изменился с тех пор, как пользователь его открывал.
  bool get hasUpdates => statusChanged || newOffersCount > 0;

  static OrderStatus _statusFrom(Object? code) => code != null
      ? OrderStatus.values[Parser.toInt(code)]
      : OrderStatus.nothing;

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
        executionDays: data['execution_days'] != null
            ? Parser.toInt(data['execution_days'])
            : null,
        user: data['user'] != null
            ? UserModel.fromJson(data['user'] as Map<String, dynamic>)
            : null,
        // status_code приходит и в списке — до сих пор он тут терялся, и
        // карточке оставалась только строка statusName, захардкоженная
        // по-русски в Order::getStatusName().
        status: _statusFrom(data['status_code']),
        statusChanged: data['status_changed'] == true,
        newOffersCount: data['new_offers_count'] is num
            ? (data['new_offers_count'] as num).toInt()
            : 0,
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
      executionDays: data['execution_days'] != null
          ? Parser.toInt(data['execution_days'])
          : null,
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
      status: _statusFrom(data['status_code']),
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
        executionDays,
        user,
        executor,
        files,
        category,
        city,
        status,
        statusChanged,
        newOffersCount
      ];
}
