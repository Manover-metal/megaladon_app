import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:megaladon/presentation/screens/auth/forgot_password_screen.dart';
import 'package:megaladon/presentation/screens/auth/login_screen.dart';
import 'package:megaladon/presentation/screens/auth/register/register_executor_screen.dart';
import 'package:megaladon/presentation/screens/auth/register/register_shop_screen.dart';
import 'package:megaladon/presentation/screens/auth/register/register_user_screen.dart';
import 'package:megaladon/presentation/screens/auth/reset_password_screen.dart';
import 'package:megaladon/presentation/screens/auth/verify_screen.dart';
import 'package:megaladon/presentation/screens/home_screen.dart';
import 'package:megaladon/presentation/screens/orders/details_order_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_executors_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_my_orders_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_orders_screen.dart';

part 'router.gr.dart';
//
// const List<AutoRoute> forms = [
// ];
//
const List<AutoRoute> order = [
  AutoRoute(
    page: ListOrdersScreen,
    path: ''
  ),
  AutoRoute(page: ListMyOrdersScreen),
  AutoRoute(page: DetailsOrderScreen),
  AutoRoute(page: ListExecutorsScreen),

];

const List<AutoRoute> auth = [
  AutoRoute(page: LoginScreen),

  AutoRoute(page: ForgotPasswordScreen),
  AutoRoute(page: ResetPasswordScreen),

  AutoRoute(page: RegisterUserScreen),
  AutoRoute(page: RegisterExecutorScreen),
  AutoRoute(page: RegisterShopScreen),
  AutoRoute(page: VerifyScreen),
];



@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: _EmptyRouteWidget,
      name: 'InitialRouter',
      path: '/',
      children: [
        AutoRoute(page: HomeScreen, initial: true),
        AutoRoute(
          page: _EmptyRouteWidget,
          name: 'OrderRouter',
          path: 'order',
          children: order
        )
      ]
    ),
    ...auth,
  ],
)

class AppRouter extends _$AppRouter {}

class _EmptyRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
