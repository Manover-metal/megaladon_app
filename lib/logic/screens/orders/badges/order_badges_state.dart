part of 'order_badges_cubit.dart';

class OrderBadgesState extends Equatable {
  const OrderBadgesState({this.badges = OrderBadges.empty});

  final OrderBadges badges;

  @override
  List<Object?> get props => [badges];
}
