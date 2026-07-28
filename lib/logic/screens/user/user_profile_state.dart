part of 'user_profile_cubit.dart';

enum UserProfileTab { adverts, services, orders }

enum LoadStatus { initial, loading, success, error }

class UserProfileState extends Equatable {
  const UserProfileState({
    this.profileStatus = LoadStatus.initial,
    this.user,
    this.tabStatus = const {},
    this.adverts = const [],
    this.services = const [],
    this.orders = const [],
  });

  final LoadStatus profileStatus;
  final UserModel? user;

  /// Статус загрузки по каждой вкладке отдельно: упавший список не должен
  /// ронять всю страницу, карточка при этом остаётся видимой.
  final Map<UserProfileTab, LoadStatus> tabStatus;

  final List<AdvertModel> adverts;
  final List<AdvertModel> services;
  final List<OrderModel> orders;

  LoadStatus statusOf(UserProfileTab tab) =>
      tabStatus[tab] ?? LoadStatus.initial;

  UserProfileState copyWith({
    LoadStatus? profileStatus,
    UserModel? user,
    Map<UserProfileTab, LoadStatus>? tabStatus,
    List<AdvertModel>? adverts,
    List<AdvertModel>? services,
    List<OrderModel>? orders,
  }) =>
      UserProfileState(
        profileStatus: profileStatus ?? this.profileStatus,
        user: user ?? this.user,
        tabStatus: tabStatus ?? this.tabStatus,
        adverts: adverts ?? this.adverts,
        services: services ?? this.services,
        orders: orders ?? this.orders,
      );

  @override
  List<Object?> get props =>
      [profileStatus, user, tabStatus, adverts, services, orders];
}
