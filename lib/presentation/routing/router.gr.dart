// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    InitialRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: SplashScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: LoginScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ForgotPasswordScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ResetPasswordScreen(),
      );
    },
    RegisterUserRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: RegisterUserScreen(),
      );
    },
    RegisterExecutorRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: RegisterExecutorScreen(),
      );
    },
    RegisterStoreRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: RegisterStoreScreen(),
      );
    },
    VerifyRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: VerifyScreen(
          key: args.key,
          phone: args.phone,
        ),
      );
    },
    CreateAdRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: CreateAdScreen(),
      );
    },
    CreateOrderRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: CreateOrderScreen(),
      );
    },
    UpdateAdRoute.name: (routeData) {
      final args = routeData.argsAs<UpdateAdRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: UpdateAdScreen(
          key: args.key,
          advert: args.advert,
        ),
      );
    },
    UpdateOrderRoute.name: (routeData) {
      final args = routeData.argsAs<UpdateOrderRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: UpdateOrderScreen(
          key: args.key,
          order: args.order,
        ),
      );
    },
    CreateOfferRoute.name: (routeData) {
      final args = routeData.argsAs<CreateOfferRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: CreateOfferScreen(
          key: args.key,
          orderId: args.orderId,
        ),
      );
    },
    OrderRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: _EmptyRouteWidget(),
      );
    },
    StoreRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: _EmptyRouteWidget(),
      );
    },
    AdRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: _EmptyRouteWidget(),
      );
    },
    ProfileRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: _EmptyRouteWidget(),
      );
    },
    ListOrdersRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ListOrdersScreen(),
      );
    },
    ListMyOrdersRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ListMyOrdersScreen(),
      );
    },
    DetailsOrderRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsOrderRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsOrderScreen(
          key: args.key,
          orderId: args.orderId,
        ),
      );
    },
    ListExecutorsRoute.name: (routeData) {
      final args = routeData.argsAs<ListExecutorsRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ListExecutorsScreen(
          key: args.key,
          orderId: args.orderId,
        ),
      );
    },
    DetailsOfferRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsOfferRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsOfferScreen(
          key: args.key,
          orderId: args.orderId,
          offerId: args.offerId,
        ),
      );
    },
    ReviewRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ReviewScreen(),
      );
    },
    ListStoresRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ListStoresScreen(),
      );
    },
    DetailsStoreRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsStoreRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsStoreScreen(
          key: args.key,
          storeId: args.storeId,
        ),
      );
    },
    TradingAdsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: TradingAdsScreen(),
      );
    },
    DetailsAdRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsAdRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsAdScreen(
          key: args.key,
          id: args.id,
        ),
      );
    },
    MyAdsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: MyAdsScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ProfileScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: SettingsScreen(),
      );
    },
    ListExecutorRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ListExecutorScreen(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          InitialRouter.name,
          path: '/',
          children: [
            RouteConfig(
              '#redirect',
              path: '',
              parent: InitialRouter.name,
              redirectTo: 'order',
              fullMatch: true,
            ),
            RouteConfig(
              OrderRouter.name,
              path: 'order',
              parent: InitialRouter.name,
              children: [
                RouteConfig(
                  ListOrdersRoute.name,
                  path: '',
                  parent: OrderRouter.name,
                ),
                RouteConfig(
                  ListMyOrdersRoute.name,
                  path: 'list-my-orders-screen',
                  parent: OrderRouter.name,
                ),
                RouteConfig(
                  DetailsOrderRoute.name,
                  path: 'details-order-screen',
                  parent: OrderRouter.name,
                ),
                RouteConfig(
                  ListExecutorsRoute.name,
                  path: 'list-executors-screen',
                  parent: OrderRouter.name,
                ),
                RouteConfig(
                  DetailsOfferRoute.name,
                  path: 'details-offer-screen',
                  parent: OrderRouter.name,
                ),
                RouteConfig(
                  ReviewRoute.name,
                  path: 'review-screen',
                  parent: OrderRouter.name,
                ),
              ],
            ),
            RouteConfig(
              StoreRouter.name,
              path: 'store',
              parent: InitialRouter.name,
              children: [
                RouteConfig(
                  ListStoresRoute.name,
                  path: '',
                  parent: StoreRouter.name,
                ),
                RouteConfig(
                  DetailsStoreRoute.name,
                  path: 'details-store-screen',
                  parent: StoreRouter.name,
                ),
              ],
            ),
            RouteConfig(
              AdRouter.name,
              path: 'ad',
              parent: InitialRouter.name,
              children: [
                RouteConfig(
                  TradingAdsRoute.name,
                  path: '',
                  parent: AdRouter.name,
                ),
                RouteConfig(
                  DetailsAdRoute.name,
                  path: 'details-ad-screen',
                  parent: AdRouter.name,
                ),
                RouteConfig(
                  MyAdsRoute.name,
                  path: 'my-ads-screen',
                  parent: AdRouter.name,
                ),
              ],
            ),
            RouteConfig(
              ProfileRouter.name,
              path: 'profile',
              parent: InitialRouter.name,
              children: [
                RouteConfig(
                  ProfileRoute.name,
                  path: '',
                  parent: ProfileRouter.name,
                ),
                RouteConfig(
                  SettingsRoute.name,
                  path: 'settings-screen',
                  parent: ProfileRouter.name,
                ),
                RouteConfig(
                  ListExecutorRoute.name,
                  path: 'list-performers-screen',
                  parent: ProfileRouter.name,
                ),
              ],
            ),
          ],
        ),
        RouteConfig(
          LoginRoute.name,
          path: '/login-screen',
        ),
        RouteConfig(
          ForgotPasswordRoute.name,
          path: '/forgot-password-screen',
        ),
        RouteConfig(
          ResetPasswordRoute.name,
          path: '/reset-password-screen',
        ),
        RouteConfig(
          RegisterUserRoute.name,
          path: '/register-user-screen',
        ),
        RouteConfig(
          RegisterExecutorRoute.name,
          path: '/register-executor-screen',
        ),
        RouteConfig(
          RegisterStoreRoute.name,
          path: '/register-store-screen',
        ),
        RouteConfig(
          VerifyRoute.name,
          path: '/verify-screen',
        ),
        RouteConfig(
          CreateAdRoute.name,
          path: '/create-ad-screen',
        ),
        RouteConfig(
          CreateOrderRoute.name,
          path: '/create-order-screen',
        ),
        RouteConfig(
          UpdateAdRoute.name,
          path: '/update-ad-screen',
        ),
        RouteConfig(
          UpdateOrderRoute.name,
          path: '/update-order-screen',
        ),
        RouteConfig(
          CreateOfferRoute.name,
          path: '/create-offer-screen',
        ),
      ];
}

/// generated route for
/// [SplashScreen]
class InitialRouter extends PageRouteInfo<void> {
  const InitialRouter({List<PageRouteInfo>? children})
      : super(
          InitialRouter.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'InitialRouter';
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login-screen',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute()
      : super(
          ForgotPasswordRoute.name,
          path: '/forgot-password-screen',
        );

  static const String name = 'ForgotPasswordRoute';
}

/// generated route for
/// [ResetPasswordScreen]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute()
      : super(
          ResetPasswordRoute.name,
          path: '/reset-password-screen',
        );

  static const String name = 'ResetPasswordRoute';
}

/// generated route for
/// [RegisterUserScreen]
class RegisterUserRoute extends PageRouteInfo<void> {
  const RegisterUserRoute()
      : super(
          RegisterUserRoute.name,
          path: '/register-user-screen',
        );

  static const String name = 'RegisterUserRoute';
}

/// generated route for
/// [RegisterExecutorScreen]
class RegisterExecutorRoute extends PageRouteInfo<void> {
  const RegisterExecutorRoute()
      : super(
          RegisterExecutorRoute.name,
          path: '/register-executor-screen',
        );

  static const String name = 'RegisterExecutorRoute';
}

/// generated route for
/// [RegisterStoreScreen]
class RegisterStoreRoute extends PageRouteInfo<void> {
  const RegisterStoreRoute()
      : super(
          RegisterStoreRoute.name,
          path: '/register-store-screen',
        );

  static const String name = 'RegisterStoreRoute';
}

/// generated route for
/// [VerifyScreen]
class VerifyRoute extends PageRouteInfo<VerifyRouteArgs> {
  VerifyRoute({
    Key? key,
    required String phone,
  }) : super(
          VerifyRoute.name,
          path: '/verify-screen',
          args: VerifyRouteArgs(
            key: key,
            phone: phone,
          ),
        );

  static const String name = 'VerifyRoute';
}

class VerifyRouteArgs {
  const VerifyRouteArgs({
    this.key,
    required this.phone,
  });

  final Key? key;

  final String phone;

  @override
  String toString() {
    return 'VerifyRouteArgs{key: $key, phone: $phone}';
  }
}

/// generated route for
/// [CreateAdScreen]
class CreateAdRoute extends PageRouteInfo<void> {
  const CreateAdRoute()
      : super(
          CreateAdRoute.name,
          path: '/create-ad-screen',
        );

  static const String name = 'CreateAdRoute';
}

/// generated route for
/// [CreateOrderScreen]
class CreateOrderRoute extends PageRouteInfo<void> {
  const CreateOrderRoute()
      : super(
          CreateOrderRoute.name,
          path: '/create-order-screen',
        );

  static const String name = 'CreateOrderRoute';
}

/// generated route for
/// [UpdateAdScreen]
class UpdateAdRoute extends PageRouteInfo<UpdateAdRouteArgs> {
  UpdateAdRoute({
    Key? key,
    required AdvertModel advert,
  }) : super(
          UpdateAdRoute.name,
          path: '/update-ad-screen',
          args: UpdateAdRouteArgs(
            key: key,
            advert: advert,
          ),
        );

  static const String name = 'UpdateAdRoute';
}

class UpdateAdRouteArgs {
  const UpdateAdRouteArgs({
    this.key,
    required this.advert,
  });

  final Key? key;

  final AdvertModel advert;

  @override
  String toString() {
    return 'UpdateAdRouteArgs{key: $key, advert: $advert}';
  }
}

/// generated route for
/// [UpdateOrderScreen]
class UpdateOrderRoute extends PageRouteInfo<UpdateOrderRouteArgs> {
  UpdateOrderRoute({
    Key? key,
    required OrderModel order,
  }) : super(
          UpdateOrderRoute.name,
          path: '/update-order-screen',
          args: UpdateOrderRouteArgs(
            key: key,
            order: order,
          ),
        );

  static const String name = 'UpdateOrderRoute';
}

class UpdateOrderRouteArgs {
  const UpdateOrderRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final OrderModel order;

  @override
  String toString() {
    return 'UpdateOrderRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [CreateOfferScreen]
class CreateOfferRoute extends PageRouteInfo<CreateOfferRouteArgs> {
  CreateOfferRoute({
    Key? key,
    required int orderId,
  }) : super(
          CreateOfferRoute.name,
          path: '/create-offer-screen',
          args: CreateOfferRouteArgs(
            key: key,
            orderId: orderId,
          ),
        );

  static const String name = 'CreateOfferRoute';
}

class CreateOfferRouteArgs {
  const CreateOfferRouteArgs({
    this.key,
    required this.orderId,
  });

  final Key? key;

  final int orderId;

  @override
  String toString() {
    return 'CreateOfferRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [_EmptyRouteWidget]
class OrderRouter extends PageRouteInfo<void> {
  const OrderRouter({List<PageRouteInfo>? children})
      : super(
          OrderRouter.name,
          path: 'order',
          initialChildren: children,
        );

  static const String name = 'OrderRouter';
}

/// generated route for
/// [_EmptyRouteWidget]
class StoreRouter extends PageRouteInfo<void> {
  const StoreRouter({List<PageRouteInfo>? children})
      : super(
          StoreRouter.name,
          path: 'store',
          initialChildren: children,
        );

  static const String name = 'StoreRouter';
}

/// generated route for
/// [_EmptyRouteWidget]
class AdRouter extends PageRouteInfo<void> {
  const AdRouter({List<PageRouteInfo>? children})
      : super(
          AdRouter.name,
          path: 'ad',
          initialChildren: children,
        );

  static const String name = 'AdRouter';
}

/// generated route for
/// [_EmptyRouteWidget]
class ProfileRouter extends PageRouteInfo<void> {
  const ProfileRouter({List<PageRouteInfo>? children})
      : super(
          ProfileRouter.name,
          path: 'profile',
          initialChildren: children,
        );

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [ListOrdersScreen]
class ListOrdersRoute extends PageRouteInfo<void> {
  const ListOrdersRoute()
      : super(
          ListOrdersRoute.name,
          path: '',
        );

  static const String name = 'ListOrdersRoute';
}

/// generated route for
/// [ListMyOrdersScreen]
class ListMyOrdersRoute extends PageRouteInfo<void> {
  const ListMyOrdersRoute()
      : super(
          ListMyOrdersRoute.name,
          path: 'list-my-orders-screen',
        );

  static const String name = 'ListMyOrdersRoute';
}

/// generated route for
/// [DetailsOrderScreen]
class DetailsOrderRoute extends PageRouteInfo<DetailsOrderRouteArgs> {
  DetailsOrderRoute({
    Key? key,
    required int orderId,
  }) : super(
          DetailsOrderRoute.name,
          path: 'details-order-screen',
          args: DetailsOrderRouteArgs(
            key: key,
            orderId: orderId,
          ),
        );

  static const String name = 'DetailsOrderRoute';
}

class DetailsOrderRouteArgs {
  const DetailsOrderRouteArgs({
    this.key,
    required this.orderId,
  });

  final Key? key;

  final int orderId;

  @override
  String toString() {
    return 'DetailsOrderRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [ListExecutorsScreen]
class ListExecutorsRoute extends PageRouteInfo<ListExecutorsRouteArgs> {
  ListExecutorsRoute({
    Key? key,
    required int orderId,
  }) : super(
          ListExecutorsRoute.name,
          path: 'list-executors-screen',
          args: ListExecutorsRouteArgs(
            key: key,
            orderId: orderId,
          ),
        );

  static const String name = 'ListExecutorsRoute';
}

class ListExecutorsRouteArgs {
  const ListExecutorsRouteArgs({
    this.key,
    required this.orderId,
  });

  final Key? key;

  final int orderId;

  @override
  String toString() {
    return 'ListExecutorsRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [DetailsOfferScreen]
class DetailsOfferRoute extends PageRouteInfo<DetailsOfferRouteArgs> {
  DetailsOfferRoute({
    Key? key,
    required int orderId,
    required int offerId,
  }) : super(
          DetailsOfferRoute.name,
          path: 'details-offer-screen',
          args: DetailsOfferRouteArgs(
            key: key,
            orderId: orderId,
            offerId: offerId,
          ),
        );

  static const String name = 'DetailsOfferRoute';
}

class DetailsOfferRouteArgs {
  const DetailsOfferRouteArgs({
    this.key,
    required this.orderId,
    required this.offerId,
  });

  final Key? key;

  final int orderId;

  final int offerId;

  @override
  String toString() {
    return 'DetailsOfferRouteArgs{key: $key, orderId: $orderId, offerId: $offerId}';
  }
}

/// generated route for
/// [ReviewScreen]
class ReviewRoute extends PageRouteInfo<void> {
  const ReviewRoute()
      : super(
          ReviewRoute.name,
          path: 'review-screen',
        );

  static const String name = 'ReviewRoute';
}

/// generated route for
/// [ListStoresScreen]
class ListStoresRoute extends PageRouteInfo<void> {
  const ListStoresRoute()
      : super(
          ListStoresRoute.name,
          path: '',
        );

  static const String name = 'ListStoresRoute';
}

/// generated route for
/// [DetailsStoreScreen]
class DetailsStoreRoute extends PageRouteInfo<DetailsStoreRouteArgs> {
  DetailsStoreRoute({
    Key? key,
    required int storeId,
  }) : super(
          DetailsStoreRoute.name,
          path: 'details-store-screen',
          args: DetailsStoreRouteArgs(
            key: key,
            storeId: storeId,
          ),
        );

  static const String name = 'DetailsStoreRoute';
}

class DetailsStoreRouteArgs {
  const DetailsStoreRouteArgs({
    this.key,
    required this.storeId,
  });

  final Key? key;

  final int storeId;

  @override
  String toString() {
    return 'DetailsStoreRouteArgs{key: $key, storeId: $storeId}';
  }
}

/// generated route for
/// [TradingAdsScreen]
class TradingAdsRoute extends PageRouteInfo<void> {
  const TradingAdsRoute()
      : super(
          TradingAdsRoute.name,
          path: '',
        );

  static const String name = 'TradingAdsRoute';
}

/// generated route for
/// [DetailsAdScreen]
class DetailsAdRoute extends PageRouteInfo<DetailsAdRouteArgs> {
  DetailsAdRoute({
    Key? key,
    required int id,
  }) : super(
          DetailsAdRoute.name,
          path: 'details-ad-screen',
          args: DetailsAdRouteArgs(
            key: key,
            id: id,
          ),
        );

  static const String name = 'DetailsAdRoute';
}

class DetailsAdRouteArgs {
  const DetailsAdRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final int id;

  @override
  String toString() {
    return 'DetailsAdRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [MyAdsScreen]
class MyAdsRoute extends PageRouteInfo<void> {
  const MyAdsRoute()
      : super(
          MyAdsRoute.name,
          path: 'my-ads-screen',
        );

  static const String name = 'MyAdsRoute';
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings-screen',
        );

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [ListExecutorScreen]
class ListExecutorRoute extends PageRouteInfo<void> {
  const ListExecutorRoute()
      : super(
          ListExecutorRoute.name,
          path: 'list-performers-screen',
        );

  static const String name = 'ListExecutorRoute';
}
