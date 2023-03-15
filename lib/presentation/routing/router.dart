import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/presentation/screens/ads/details_ad_screen.dart';
import 'package:megaladon/presentation/screens/ads/my_ads_screen.dart';
import 'package:megaladon/presentation/screens/ads/trading_ads_screen.dart';
import 'package:megaladon/presentation/screens/auth/forgot_password_screen.dart';
import 'package:megaladon/presentation/screens/auth/login_screen.dart';
import 'package:megaladon/presentation/screens/auth/register/register_executor_screen.dart';
import 'package:megaladon/presentation/screens/auth/register/register_shop_screen.dart';
import 'package:megaladon/presentation/screens/auth/register/register_user_screen.dart';
import 'package:megaladon/presentation/screens/auth/reset_password_screen.dart';
import 'package:megaladon/presentation/screens/auth/verify_screen.dart';
import 'package:megaladon/presentation/screens/chat/list_chats_screen.dart';
import 'package:megaladon/presentation/screens/forms/ad/create_ad_screen.dart';
import 'package:megaladon/presentation/screens/forms/ad/update_ad_screen.dart';
import 'package:megaladon/presentation/screens/forms/offer/create_offer_screen.dart';
import 'package:megaladon/presentation/screens/forms/order/create_order_screen.dart';
import 'package:megaladon/presentation/screens/forms/order/update_order_screen.dart';
import 'package:megaladon/presentation/screens/orders/details_offer_screen.dart';
import 'package:megaladon/presentation/screens/orders/details_order_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_executors_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_my_orders_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_orders_screen.dart';
import 'package:megaladon/presentation/screens/orders/review_screen.dart';
import 'package:megaladon/presentation/screens/profile/profile_screen.dart';
import 'package:megaladon/presentation/screens/profile/settings_screen.dart';
import 'package:megaladon/presentation/screens/store/details_store_screen.dart';
import 'package:megaladon/presentation/screens/store/list_stores_screen.dart';
import 'package:megaladon/presentation/screens/splash_screen.dart';


part 'router.gr.dart';

const List<AutoRoute> profile = [
  AutoRoute(page: ProfileScreen, path: ''),
  AutoRoute(page: SettingsScreen),
  AutoRoute(page: ListChatsScreen),
];

const List<AutoRoute> ad = [
  AutoRoute(page: TradingAdsScreen, path: ''),
  AutoRoute(page: DetailsAdScreen),
  AutoRoute(page: MyAdsScreen),
];

const List<AutoRoute> store = [
  AutoRoute(page: ListStoresScreen, path: ''),
  AutoRoute(page: DetailsStoreScreen),
];

const List<AutoRoute> order = [
  AutoRoute(page: ListOrdersScreen, path: ''),
  AutoRoute(page: ListMyOrdersScreen),
  AutoRoute(page: DetailsOrderScreen),
  AutoRoute(page: ListExecutorsScreen),
  AutoRoute(page: DetailsOfferScreen),
  AutoRoute(page: ReviewScreen)
];

const List<AutoRoute> auth = [
  AutoRoute(page: LoginScreen),
  AutoRoute(page: ForgotPasswordScreen),
  AutoRoute(page: ResetPasswordScreen),
  AutoRoute(page: RegisterUserScreen),
  AutoRoute(page: RegisterExecutorScreen),
  AutoRoute(page: RegisterStoreScreen),
  AutoRoute(page: VerifyScreen),
];

const List<AutoRoute> form = [
  AutoRoute(page: CreateAdScreen),
  AutoRoute(page: CreateOrderScreen),
  AutoRoute(page: UpdateAdScreen),
  AutoRoute(page: UpdateOrderScreen),
  AutoRoute(page: CreateOfferScreen)
];


@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, name: 'InitialRouter', path: '/', children: [
      AutoRoute(
          page: _EmptyRouteWidget,
          name: 'OrderRouter',
          path: 'order',
          children: order,
          initial: true),
      AutoRoute(
          page: _EmptyRouteWidget,
          name: 'StoreRouter',
          path: 'store',
          children: store),
      AutoRoute(
          page: _EmptyRouteWidget, name: 'AdRouter', path: 'ad', children: ad),
      AutoRoute(
          page: _EmptyRouteWidget,
          name: 'ProfileRouter',
          path: 'profile',
          children: profile),

      // create_ratkum
     
    ]),
    ...auth,
    ...form
  ],
)
class AppRouter extends _$AppRouter {}

class _EmptyRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
