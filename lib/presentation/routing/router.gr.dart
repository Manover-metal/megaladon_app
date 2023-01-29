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
        child: _EmptyRouteWidget(),
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
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: HomeScreen(),
      );
    },
    OrderRouter.name: (routeData) {
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
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          InitialRouter.name,
          path: '/',
          children: [
            RouteConfig(
              HomeRoute.name,
              path: '',
              parent: InitialRouter.name,
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
      ];
}

/// generated route for
/// [_EmptyRouteWidget]
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
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '',
        );

  static const String name = 'HomeRoute';
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
