import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

  /// Цвет статуса для списков. Пары подобраны под обе темы: в тёмной те же
  /// оттенки уходят в грязь, поэтому каждый осветлён отдельно.
  Color color(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (this) {
      case OrderStatus.moderate:
        return isDark ? const Color(0xFFC7C4C2) : const Color(0xFF64748B);
      case OrderStatus.active:
        return isDark ? const Color(0xFF5BC4B4) : const Color(0xFF0F766E);
      case OrderStatus.hasExecutor:
        return isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
      case OrderStatus.completed:
        return isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);
      case OrderStatus.archive:
        return isDark ? const Color(0xFF7A7674) : const Color(0xFF94A3B8);
      case OrderStatus.nothing:
        return Theme.of(context).colorScheme.secondary;
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

  /// Цены хранятся числом: строку из них делает представление. Раньше
  /// модель держала уже отформатированный текст, и его приходилось разбирать
  /// обратно — например, чтобы подставить цену в форму редактирования.
  final double? priceRecommended;
  final double? priceMax;
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

  /// Цены с разделителями разрядов — то, что показывают карточка и экран.
  /// Ноль бэкенд присылает вместо «не указана», поэтому показывать его как
  /// цену нельзя: для пустой и нулевой цены текста нет.
  String? get priceRecommendedText => _priceText(priceRecommended);

  String? get priceMaxText => _priceText(priceMax);

  static String? _priceText(double? price) =>
      price != null && price > 0 ? Parser.toPrice(price) : null;

  static OrderStatus _statusFrom(Object? code) => code != null
      ? OrderStatus.values[Parser.toInt(code)]
      : OrderStatus.nothing;

  static OrderModel fromJsonMini(Map<String, dynamic> data) => OrderModel(
        id: data['id'] as int,
        title: data['title'] as String,
        description: data['description'] as String,
        priceRecommended: data['price_recommended'] != null
            ? Parser.toDouble(data['price_recommended'])
            : null,
        priceMax: data['price_max'] != null
            ? Parser.toDouble(data['price_max'])
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
        // Город бэкенд отдаёт и в списке (OrderPresenter::list), но до сих
        // пор он тут терялся — карточке его показать было неоткуда.
        city: data['city'] != null && (data['city'] as Map)['id'] != null
            ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
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
          ? Parser.toDouble(data['price_recommended'])
          : null,
      priceMax:
          data['price_max'] != null ? Parser.toDouble(data['price_max']) : null,
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
