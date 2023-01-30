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
    RegisterShopRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: RegisterShopScreen(),
      );
    },
    VerifyRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: VerifyScreen(),
      );
    },
    CreateOfferRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: CreateOfferScreen(),
      );
    },
    OrderRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: _EmptyRouteWidget(),
      );
    },
    ShopRouter.name: (routeData) {
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
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsOrderScreen(),
      );
    },
    ListExecutorsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ListExecutorsScreen(),
      );
    },
    DetailsOfferRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsOfferScreen(),
      );
    },
    ReviewRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ReviewScreen(),
      );
    },
    ListShopsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ListShopsScreen(),
      );
    },
    DetailsShopRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsShopScreen(),
      );
    },
    TradingAdsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: TradingAdsScreen(),
      );
    },
    DetailsAdRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsAdScreen(),
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
              ShopRouter.name,
              path: 'shop',
              parent: InitialRouter.name,
              children: [
                RouteConfig(
                  ListShopsRoute.name,
                  path: '',
                  parent: ShopRouter.name,
                ),
                RouteConfig(
                  DetailsShopRoute.name,
                  path: 'details-shop-screen',
                  parent: ShopRouter.name,
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
                )
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
          RegisterShopRoute.name,
          path: '/register-shop-screen',
        ),
        RouteConfig(
          VerifyRoute.name,
          path: '/verify-screen',
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
/// [RegisterShopScreen]
class RegisterShopRoute extends PageRouteInfo<void> {
  const RegisterShopRoute()
      : super(
          RegisterShopRoute.name,
          path: '/register-shop-screen',
        );

  static const String name = 'RegisterShopRoute';
}

/// generated route for
/// [VerifyScreen]
class VerifyRoute extends PageRouteInfo<void> {
  const VerifyRoute()
      : super(
          VerifyRoute.name,
          path: '/verify-screen',
        );

  static const String name = 'VerifyRoute';
}

/// generated route for
/// [CreateOfferScreen]
class CreateOfferRoute extends PageRouteInfo<void> {
  const CreateOfferRoute()
      : super(
          CreateOfferRoute.name,
          path: '/create-offer-screen',
        );

  static const String name = 'CreateOfferRoute';
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
class ShopRouter extends PageRouteInfo<void> {
  const ShopRouter({List<PageRouteInfo>? children})
      : super(
          ShopRouter.name,
          path: 'shop',
          initialChildren: children,
        );

  static const String name = 'ShopRouter';
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
class DetailsOrderRoute extends PageRouteInfo<void> {
  const DetailsOrderRoute()
      : super(
          DetailsOrderRoute.name,
          path: 'details-order-screen',
        );

  static const String name = 'DetailsOrderRoute';
}

/// generated route for
/// [ListExecutorsScreen]
class ListExecutorsRoute extends PageRouteInfo<void> {
  const ListExecutorsRoute()
      : super(
          ListExecutorsRoute.name,
          path: 'list-executors-screen',
        );

  static const String name = 'ListExecutorsRoute';
}

/// generated route for
/// [DetailsOfferScreen]
class DetailsOfferRoute extends PageRouteInfo<void> {
  const DetailsOfferRoute()
      : super(
          DetailsOfferRoute.name,
          path: 'details-offer-screen',
        );

  static const String name = 'DetailsOfferRoute';
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
/// [ListShopsScreen]
class ListShopsRoute extends PageRouteInfo<void> {
  const ListShopsRoute()
      : super(
          ListShopsRoute.name,
          path: '',
        );

  static const String name = 'ListShopsRoute';
}

/// generated route for
/// [DetailsShopScreen]
class DetailsShopRoute extends PageRouteInfo<void> {
  const DetailsShopRoute()
      : super(
          DetailsShopRoute.name,
          path: 'details-shop-screen',
        );

  static const String name = 'DetailsShopRoute';
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
class DetailsAdRoute extends PageRouteInfo<void> {
  const DetailsAdRoute()
      : super(
          DetailsAdRoute.name,
          path: 'details-ad-screen',
        );

  static const String name = 'DetailsAdRoute';
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
