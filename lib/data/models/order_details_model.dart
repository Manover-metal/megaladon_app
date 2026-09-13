import 'package:megaladon/data/models/order_model.dart';

/// Ответ `GET /order/{id}`: сам заказ и отклик смотрящего, если он на этот
/// заказ уже откликался. По [myOfferId] карточка заказа вместо «Предложить
/// услуги» показывает «Посмотреть предложение» — второй отклик бэкенд всё
/// равно отклоняет (406 already_offered).
class OrderDetailsModel {
  const OrderDetailsModel({required this.order, this.myOfferId});

  final OrderModel order;

  /// null — не откликался (или бэкенд старый и поля ещё не отдаёт).
  final int? myOfferId;

  static OrderDetailsModel fromJson(Map<String, dynamic> data) =>
      OrderDetailsModel(
        order: OrderModel.fromJsonFull(data['order'] as Map<String, dynamic>),
        myOfferId: data['my_offer_id'] as int?,
      );
}
