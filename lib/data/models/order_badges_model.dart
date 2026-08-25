import 'package:equatable/equatable.dart';

/// Счётчики изменившихся заказов для бейджей: `GET /order/badges`.
class OrderBadges extends Equatable {
  const OrderBadges({this.my = 0, this.responded = 0});

  /// Заказы пользователя, где сменился статус или прибавились отклики.
  final int my;

  /// Заказы, где пользователь назначен исполнителем и сменился статус.
  final int responded;

  int get total => my + responded;

  static const OrderBadges empty = OrderBadges();

  static OrderBadges parse(Object? data) {
    final badges = data is Map ? data['badges'] : null;
    if (badges is! Map) {
      return empty;
    }
    return OrderBadges(
      my: _toInt(badges['my']),
      responded: _toInt(badges['responded']),
    );
  }

  static int _toInt(Object? value) => value is num ? value.toInt() : 0;

  @override
  List<Object?> get props => [my, responded];
}
