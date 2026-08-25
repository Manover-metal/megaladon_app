import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/presentation/routing/guards/auth_guard.dart';
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
import 'package:megaladon/presentation/screens/chat/details_chat_screen.dart';
import 'package:megaladon/presentation/screens/chat/list_chats_screen.dart';
import 'package:megaladon/presentation/screens/executor/executor_details_screen.dart';
import 'package:megaladon/presentation/screens/executor/list_my_executors_screen.dart';
import 'package:megaladon/presentation/screens/forms/ad/create_ad_screen.dart';
import 'package:megaladon/presentation/screens/forms/ad/update_ad_screen.dart';
import 'package:megaladon/presentation/screens/forms/executor/change_executor_screen.dart';
import 'package:megaladon/presentation/screens/forms/offer/create_offer_screen.dart';
import 'package:megaladon/presentation/screens/forms/order/create_order_screen.dart';
import 'package:megaladon/presentation/screens/forms/order/update_order_screen.dart';
import 'package:megaladon/presentation/screens/forms/store/change_shop_screen.dart';
import 'package:megaladon/presentation/screens/orders/details_offer_screen.dart';
import 'package:megaladon/presentation/screens/orders/details_order_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_executors_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_my_orders_screen.dart';
import 'package:megaladon/presentation/screens/orders/list_orders_screen.dart';
import 'package:megaladon/presentation/screens/orders/review_screen.dart';
import 'package:megaladon/presentation/screens/profile/about_screen.dart';
import 'package:megaladon/presentation/screens/profile/change_password_screen.dart';
import 'package:megaladon/presentation/screens/profile/change_phone_end_screen.dart';
import 'package:megaladon/presentation/screens/profile/change_phone_start_screen.dart';
import 'package:megaladon/presentation/screens/profile/my_reviews_screen.dart';
import 'package:megaladon/presentation/screens/profile/profile_screen.dart';
import 'package:megaladon/presentation/screens/profile/settings_screen.dart';
import 'package:megaladon/presentation/screens/splash_screen.dart';
import 'package:megaladon/presentation/screens/store/details_store_screen.dart';
import 'package:megaladon/presentation/screens/store/list_stores_screen.dart';
import 'package:megaladon/presentation/screens/store/store_my_reviews_screen.dart';
import 'package:megaladon/presentation/screens/subscribe/subscribe_screen.dart';
import 'package:megaladon/presentation/screens/user/user_profile_screen.dart';

part 'router.gr.dart';

const List<AutoRoute> profile = [
  AutoRoute(page: ProfileScreen, path: ''),
  AutoRoute(page: SettingsScreen),
  AutoRoute(page: ChangeExecutorScreen, guards: [AuthGuard]),
  AutoRoute(page: ChangeStoreScreen, guards: [AuthGuard]),
  AutoRoute(page: ListChatsScreen, guards: [AuthGuard]),
  AutoRoute(page: MyReviewsScreen, guards: [AuthGuard]),
  AutoRoute(page: StoreMyReviewsScreen, guards: [AuthGuard]),
  AutoRoute(page: AboutScreen),
];

const List<AutoRoute> ad = [
  AutoRoute(page: TradingAdsScreen, path: ''),
  AutoRoute(page: DetailsAdScreen),
  AutoRoute(page: MyAdsScreen, guards: [AuthGuard]),
  // Страница публичная, гварда нет. Дублируется в ветке order — переход
  // идёт и с детального экрана объявления, и с детального экрана заказа.
  AutoRoute(page: UserProfileScreen),
];

const List<AutoRoute> store = [
  AutoRoute(page: ListStoresScreen, path: ''),
  AutoRoute(page: DetailsStoreScreen),
];

const List<AutoRoute> order = [
  AutoRoute(page: ListOrdersScreen, path: ''),
  AutoRoute(page: ListMyOrdersScreen, guards: [AuthGuard]),
  AutoRoute(page: DetailsOrderScreen),
  AutoRoute(page: ListMyExecutorsScreen, guards: [AuthGuard]),
  AutoRoute(page: DetailsExecutorScreen, guards: [AuthGuard]),
  AutoRoute(page: ListExecutorsScreen),
  AutoRoute(page: DetailsOfferScreen),
  AutoRoute(page: ReviewScreen),
  AutoRoute(page: SubscribeScreen, guards: [AuthGuard]),
  AutoRoute(page: UserProfileScreen),
];

const List<AutoRoute> auth = [
  AutoRoute(page: LoginScreen, guards: [NotAuthGuard]),
  AutoRoute(page: ForgotPasswordScreen, guards: [NotAuthGuard]),
  AutoRoute(page: ResetPasswordScreen, guards: [NotAuthGuard]),
  AutoRoute(page: RegisterUserScreen, guards: [NotAuthGuard]),
  AutoRoute(page: RegisterExecutorScreen),
  AutoRoute(page: RegisterStoreScreen),
  AutoRoute(page: VerifyScreen, guards: [NotAuthGuard]),
];

const List<AutoRoute> form = [
  AutoRoute(page: CreateAdScreen, guards: [AuthGuard]),
  AutoRoute(page: CreateOrderScreen, guards: [AuthGuard]),
  AutoRoute(page: UpdateAdScreen, guards: [AuthGuard]),
  AutoRoute(page: UpdateOrderScreen, guards: [AuthGuard]),
  AutoRoute(page: CreateOfferScreen, guards: [AuthGuard]),
  AutoRoute(page: ChangePasswordScreen, guards: [AuthGuard]),
  AutoRoute(page: ChangePhoneStartScreen, guards: [AuthGuard]),
  AutoRoute(page: ChangePhoneEndScreen, guards: [AuthGuard]),
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
    ]),
    AutoRoute(
      page: DetailsChatScreen,
      name: 'DetailsChatRouter',
    ),
    // Третья регистрация профиля (кроме ветвей ad и order): экран переписки
    // лежит в корне роутера, поэтому context.router в шапке чата — корневой
    // StackRouter, и маршрут должен быть среди его детей. Путь задан явно:
    // генератор требует, чтобы одноимённые маршруты объявляли одинаковый
    // сегмент, а корневому по умолчанию досталось бы «/user-profile-screen».
    AutoRoute(page: UserProfileScreen, path: 'user-profile-screen'),
    ...auth,
    ...form
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({required super.notAuthGuard, required super.authGuard});
}

class _EmptyRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const AutoRouter();
}
