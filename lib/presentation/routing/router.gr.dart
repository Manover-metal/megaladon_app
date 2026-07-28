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
  _$AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.notAuthGuard,
    required this.authGuard,
  }) : super(navigatorKey);

  final NotAuthGuard notAuthGuard;

  final AuthGuard authGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    InitialRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    DetailsChatRouter.name: (routeData) {
      final args = routeData.argsAs<DetailsChatRouterArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsChatScreen(
          chat: args.chat,
          key: args.key,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      final args = routeData.argsAs<ResetPasswordRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ResetPasswordScreen(
          phone: args.phone,
          key: args.key,
        ),
      );
    },
    RegisterUserRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RegisterUserScreen(),
      );
    },
    RegisterExecutorRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RegisterExecutorScreen(),
      );
    },
    RegisterStoreRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RegisterStoreScreen(),
      );
    },
    VerifyRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: VerifyScreen(
          phone: args.phone,
          key: args.key,
        ),
      );
    },
    CreateAdRoute.name: (routeData) {
      final args = routeData.argsAs<CreateAdRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: CreateAdScreen(
          type: args.type,
          key: args.key,
        ),
      );
    },
    CreateOrderRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CreateOrderScreen(),
      );
    },
    UpdateAdRoute.name: (routeData) {
      final args = routeData.argsAs<UpdateAdRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: UpdateAdScreen(
          advert: args.advert,
          type: args.type,
          key: args.key,
        ),
      );
    },
    UpdateOrderRoute.name: (routeData) {
      final args = routeData.argsAs<UpdateOrderRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: UpdateOrderScreen(
          order: args.order,
          key: args.key,
        ),
      );
    },
    CreateOfferRoute.name: (routeData) {
      final args = routeData.argsAs<CreateOfferRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: CreateOfferScreen(
          orderId: args.orderId,
          key: args.key,
        ),
      );
    },
    ChangePasswordRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ChangePasswordScreen(),
      );
    },
    ChangePhoneStartRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ChangePhoneStartScreen(),
      );
    },
    ChangePhoneEndRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ChangePhoneEndScreen(),
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
        child: const ListOrdersScreen(),
      );
    },
    ListMyOrdersRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ListMyOrdersScreen(),
      );
    },
    DetailsOrderRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsOrderRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsOrderScreen(
          orderId: args.orderId,
          key: args.key,
        ),
      );
    },
    ListMyExecutorsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ListMyExecutorsScreen(),
      );
    },
    DetailsExecutorRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsExecutorRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsExecutorScreen(
          executorId: args.executorId,
          key: args.key,
        ),
      );
    },
    ListExecutorsRoute.name: (routeData) {
      final args = routeData.argsAs<ListExecutorsRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ListExecutorsScreen(
          orderId: args.orderId,
          key: args.key,
        ),
      );
    },
    DetailsOfferRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsOfferRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsOfferScreen(
          orderId: args.orderId,
          offerId: args.offerId,
          key: args.key,
        ),
      );
    },
    ReviewRoute.name: (routeData) {
      final args = routeData.argsAs<ReviewRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ReviewScreen(
          order: args.order,
          key: args.key,
        ),
      );
    },
    SubscribeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SubscribeScreen(),
      );
    },
    UserProfileRoute.name: (routeData) {
      final args = routeData.argsAs<UserProfileRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: UserProfileScreen(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    ListStoresRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ListStoresScreen(),
      );
    },
    DetailsStoreRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsStoreRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsStoreScreen(
          storeId: args.storeId,
          key: args.key,
        ),
      );
    },
    TradingAdsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const TradingAdsScreen(),
      );
    },
    DetailsAdRoute.name: (routeData) {
      final args = routeData.argsAs<DetailsAdRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailsAdScreen(
          id: args.id,
          key: args.key,
        ),
      );
    },
    MyAdsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MyAdsScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
    ChangeExecutorRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ChangeExecutorScreen(),
      );
    },
    ChangeStoreRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ChangeStoreScreen(),
      );
    },
    ListChatsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ListChatsScreen(),
      );
    },
    MyReviewsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MyReviewsScreen(),
      );
    },
    StoreMyReviewsRoute.name: (routeData) {
      final args = routeData.argsAs<StoreMyReviewsRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: StoreMyReviewsScreen(
          storeId: args.storeId,
          key: args.key,
        ),
      );
    },
    AboutRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const AboutScreen(),
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
                  guards: [authGuard],
                ),
                RouteConfig(
                  DetailsOrderRoute.name,
                  path: 'details-order-screen',
                  parent: OrderRouter.name,
                ),
                RouteConfig(
                  ListMyExecutorsRoute.name,
                  path: 'list-my-executors-screen',
                  parent: OrderRouter.name,
                  guards: [authGuard],
                ),
                RouteConfig(
                  DetailsExecutorRoute.name,
                  path: 'details-executor-screen',
                  parent: OrderRouter.name,
                  guards: [authGuard],
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
                RouteConfig(
                  SubscribeRoute.name,
                  path: 'subscribe-screen',
                  parent: OrderRouter.name,
                  guards: [authGuard],
                ),
                RouteConfig(
                  UserProfileRoute.name,
                  path: 'user-profile-screen',
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
                  guards: [authGuard],
                ),
                RouteConfig(
                  UserProfileRoute.name,
                  path: 'user-profile-screen',
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
                  ChangeExecutorRoute.name,
                  path: 'change-executor-screen',
                  parent: ProfileRouter.name,
                  guards: [authGuard],
                ),
                RouteConfig(
                  ChangeStoreRoute.name,
                  path: 'change-store-screen',
                  parent: ProfileRouter.name,
                  guards: [authGuard],
                ),
                RouteConfig(
                  ListChatsRoute.name,
                  path: 'list-chats-screen',
                  parent: ProfileRouter.name,
                  guards: [authGuard],
                ),
                RouteConfig(
                  MyReviewsRoute.name,
                  path: 'my-reviews-screen',
                  parent: ProfileRouter.name,
                  guards: [authGuard],
                ),
                RouteConfig(
                  StoreMyReviewsRoute.name,
                  path: 'store-my-reviews-screen',
                  parent: ProfileRouter.name,
                  guards: [authGuard],
                ),
                RouteConfig(
                  AboutRoute.name,
                  path: 'about-screen',
                  parent: ProfileRouter.name,
                ),
              ],
            ),
          ],
        ),
        RouteConfig(
          DetailsChatRouter.name,
          path: '/details-chat-screen',
        ),
        RouteConfig(
          LoginRoute.name,
          path: '/login-screen',
          guards: [notAuthGuard],
        ),
        RouteConfig(
          ForgotPasswordRoute.name,
          path: '/forgot-password-screen',
          guards: [notAuthGuard],
        ),
        RouteConfig(
          ResetPasswordRoute.name,
          path: '/reset-password-screen',
          guards: [notAuthGuard],
        ),
        RouteConfig(
          RegisterUserRoute.name,
          path: '/register-user-screen',
          guards: [notAuthGuard],
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
          guards: [notAuthGuard],
        ),
        RouteConfig(
          CreateAdRoute.name,
          path: '/create-ad-screen',
          guards: [authGuard],
        ),
        RouteConfig(
          CreateOrderRoute.name,
          path: '/create-order-screen',
          guards: [authGuard],
        ),
        RouteConfig(
          UpdateAdRoute.name,
          path: '/update-ad-screen',
          guards: [authGuard],
        ),
        RouteConfig(
          UpdateOrderRoute.name,
          path: '/update-order-screen',
          guards: [authGuard],
        ),
        RouteConfig(
          CreateOfferRoute.name,
          path: '/create-offer-screen',
          guards: [authGuard],
        ),
        RouteConfig(
          ChangePasswordRoute.name,
          path: '/change-password-screen',
          guards: [authGuard],
        ),
        RouteConfig(
          ChangePhoneStartRoute.name,
          path: '/change-phone-start-screen',
          guards: [authGuard],
        ),
        RouteConfig(
          ChangePhoneEndRoute.name,
          path: '/change-phone-end-screen',
          guards: [authGuard],
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
/// [DetailsChatScreen]
class DetailsChatRouter extends PageRouteInfo<DetailsChatRouterArgs> {
  DetailsChatRouter({
    required ChatModel chat,
    Key? key,
  }) : super(
          DetailsChatRouter.name,
          path: '/details-chat-screen',
          args: DetailsChatRouterArgs(
            chat: chat,
            key: key,
          ),
        );

  static const String name = 'DetailsChatRouter';
}

class DetailsChatRouterArgs {
  const DetailsChatRouterArgs({
    required this.chat,
    this.key,
  });

  final ChatModel chat;

  final Key? key;

  @override
  String toString() {
    return 'DetailsChatRouterArgs{chat: $chat, key: $key}';
  }
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
class ResetPasswordRoute extends PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    required String phone,
    Key? key,
  }) : super(
          ResetPasswordRoute.name,
          path: '/reset-password-screen',
          args: ResetPasswordRouteArgs(
            phone: phone,
            key: key,
          ),
        );

  static const String name = 'ResetPasswordRoute';
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({
    required this.phone,
    this.key,
  });

  final String phone;

  final Key? key;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{phone: $phone, key: $key}';
  }
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
    required String phone,
    Key? key,
  }) : super(
          VerifyRoute.name,
          path: '/verify-screen',
          args: VerifyRouteArgs(
            phone: phone,
            key: key,
          ),
        );

  static const String name = 'VerifyRoute';
}

class VerifyRouteArgs {
  const VerifyRouteArgs({
    required this.phone,
    this.key,
  });

  final String phone;

  final Key? key;

  @override
  String toString() {
    return 'VerifyRouteArgs{phone: $phone, key: $key}';
  }
}

/// generated route for
/// [CreateAdScreen]
class CreateAdRoute extends PageRouteInfo<CreateAdRouteArgs> {
  CreateAdRoute({
    required AdvertType type,
    Key? key,
  }) : super(
          CreateAdRoute.name,
          path: '/create-ad-screen',
          args: CreateAdRouteArgs(
            type: type,
            key: key,
          ),
        );

  static const String name = 'CreateAdRoute';
}

class CreateAdRouteArgs {
  const CreateAdRouteArgs({
    required this.type,
    this.key,
  });

  final AdvertType type;

  final Key? key;

  @override
  String toString() {
    return 'CreateAdRouteArgs{type: $type, key: $key}';
  }
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
    required AdvertModel advert,
    required AdvertType type,
    Key? key,
  }) : super(
          UpdateAdRoute.name,
          path: '/update-ad-screen',
          args: UpdateAdRouteArgs(
            advert: advert,
            type: type,
            key: key,
          ),
        );

  static const String name = 'UpdateAdRoute';
}

class UpdateAdRouteArgs {
  const UpdateAdRouteArgs({
    required this.advert,
    required this.type,
    this.key,
  });

  final AdvertModel advert;

  final AdvertType type;

  final Key? key;

  @override
  String toString() {
    return 'UpdateAdRouteArgs{advert: $advert, type: $type, key: $key}';
  }
}

/// generated route for
/// [UpdateOrderScreen]
class UpdateOrderRoute extends PageRouteInfo<UpdateOrderRouteArgs> {
  UpdateOrderRoute({
    required OrderModel order,
    Key? key,
  }) : super(
          UpdateOrderRoute.name,
          path: '/update-order-screen',
          args: UpdateOrderRouteArgs(
            order: order,
            key: key,
          ),
        );

  static const String name = 'UpdateOrderRoute';
}

class UpdateOrderRouteArgs {
  const UpdateOrderRouteArgs({
    required this.order,
    this.key,
  });

  final OrderModel order;

  final Key? key;

  @override
  String toString() {
    return 'UpdateOrderRouteArgs{order: $order, key: $key}';
  }
}

/// generated route for
/// [CreateOfferScreen]
class CreateOfferRoute extends PageRouteInfo<CreateOfferRouteArgs> {
  CreateOfferRoute({
    required int orderId,
    Key? key,
  }) : super(
          CreateOfferRoute.name,
          path: '/create-offer-screen',
          args: CreateOfferRouteArgs(
            orderId: orderId,
            key: key,
          ),
        );

  static const String name = 'CreateOfferRoute';
}

class CreateOfferRouteArgs {
  const CreateOfferRouteArgs({
    required this.orderId,
    this.key,
  });

  final int orderId;

  final Key? key;

  @override
  String toString() {
    return 'CreateOfferRouteArgs{orderId: $orderId, key: $key}';
  }
}

/// generated route for
/// [ChangePasswordScreen]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute()
      : super(
          ChangePasswordRoute.name,
          path: '/change-password-screen',
        );

  static const String name = 'ChangePasswordRoute';
}

/// generated route for
/// [ChangePhoneStartScreen]
class ChangePhoneStartRoute extends PageRouteInfo<void> {
  const ChangePhoneStartRoute()
      : super(
          ChangePhoneStartRoute.name,
          path: '/change-phone-start-screen',
        );

  static const String name = 'ChangePhoneStartRoute';
}

/// generated route for
/// [ChangePhoneEndScreen]
class ChangePhoneEndRoute extends PageRouteInfo<void> {
  const ChangePhoneEndRoute()
      : super(
          ChangePhoneEndRoute.name,
          path: '/change-phone-end-screen',
        );

  static const String name = 'ChangePhoneEndRoute';
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
    required int orderId,
    Key? key,
  }) : super(
          DetailsOrderRoute.name,
          path: 'details-order-screen',
          args: DetailsOrderRouteArgs(
            orderId: orderId,
            key: key,
          ),
        );

  static const String name = 'DetailsOrderRoute';
}

class DetailsOrderRouteArgs {
  const DetailsOrderRouteArgs({
    required this.orderId,
    this.key,
  });

  final int orderId;

  final Key? key;

  @override
  String toString() {
    return 'DetailsOrderRouteArgs{orderId: $orderId, key: $key}';
  }
}

/// generated route for
/// [ListMyExecutorsScreen]
class ListMyExecutorsRoute extends PageRouteInfo<void> {
  const ListMyExecutorsRoute()
      : super(
          ListMyExecutorsRoute.name,
          path: 'list-my-executors-screen',
        );

  static const String name = 'ListMyExecutorsRoute';
}

/// generated route for
/// [DetailsExecutorScreen]
class DetailsExecutorRoute extends PageRouteInfo<DetailsExecutorRouteArgs> {
  DetailsExecutorRoute({
    required int executorId,
    Key? key,
  }) : super(
          DetailsExecutorRoute.name,
          path: 'details-executor-screen',
          args: DetailsExecutorRouteArgs(
            executorId: executorId,
            key: key,
          ),
        );

  static const String name = 'DetailsExecutorRoute';
}

class DetailsExecutorRouteArgs {
  const DetailsExecutorRouteArgs({
    required this.executorId,
    this.key,
  });

  final int executorId;

  final Key? key;

  @override
  String toString() {
    return 'DetailsExecutorRouteArgs{executorId: $executorId, key: $key}';
  }
}

/// generated route for
/// [ListExecutorsScreen]
class ListExecutorsRoute extends PageRouteInfo<ListExecutorsRouteArgs> {
  ListExecutorsRoute({
    required int orderId,
    Key? key,
  }) : super(
          ListExecutorsRoute.name,
          path: 'list-executors-screen',
          args: ListExecutorsRouteArgs(
            orderId: orderId,
            key: key,
          ),
        );

  static const String name = 'ListExecutorsRoute';
}

class ListExecutorsRouteArgs {
  const ListExecutorsRouteArgs({
    required this.orderId,
    this.key,
  });

  final int orderId;

  final Key? key;

  @override
  String toString() {
    return 'ListExecutorsRouteArgs{orderId: $orderId, key: $key}';
  }
}

/// generated route for
/// [DetailsOfferScreen]
class DetailsOfferRoute extends PageRouteInfo<DetailsOfferRouteArgs> {
  DetailsOfferRoute({
    required int orderId,
    required int offerId,
    Key? key,
  }) : super(
          DetailsOfferRoute.name,
          path: 'details-offer-screen',
          args: DetailsOfferRouteArgs(
            orderId: orderId,
            offerId: offerId,
            key: key,
          ),
        );

  static const String name = 'DetailsOfferRoute';
}

class DetailsOfferRouteArgs {
  const DetailsOfferRouteArgs({
    required this.orderId,
    required this.offerId,
    this.key,
  });

  final int orderId;

  final int offerId;

  final Key? key;

  @override
  String toString() {
    return 'DetailsOfferRouteArgs{orderId: $orderId, offerId: $offerId, key: $key}';
  }
}

/// generated route for
/// [ReviewScreen]
class ReviewRoute extends PageRouteInfo<ReviewRouteArgs> {
  ReviewRoute({
    required OrderModel order,
    Key? key,
  }) : super(
          ReviewRoute.name,
          path: 'review-screen',
          args: ReviewRouteArgs(
            order: order,
            key: key,
          ),
        );

  static const String name = 'ReviewRoute';
}

class ReviewRouteArgs {
  const ReviewRouteArgs({
    required this.order,
    this.key,
  });

  final OrderModel order;

  final Key? key;

  @override
  String toString() {
    return 'ReviewRouteArgs{order: $order, key: $key}';
  }
}

/// generated route for
/// [SubscribeScreen]
class SubscribeRoute extends PageRouteInfo<void> {
  const SubscribeRoute()
      : super(
          SubscribeRoute.name,
          path: 'subscribe-screen',
        );

  static const String name = 'SubscribeRoute';
}

/// generated route for
/// [UserProfileScreen]
class UserProfileRoute extends PageRouteInfo<UserProfileRouteArgs> {
  UserProfileRoute({
    required int userId,
    Key? key,
  }) : super(
          UserProfileRoute.name,
          path: 'user-profile-screen',
          args: UserProfileRouteArgs(
            userId: userId,
            key: key,
          ),
        );

  static const String name = 'UserProfileRoute';
}

class UserProfileRouteArgs {
  const UserProfileRouteArgs({
    required this.userId,
    this.key,
  });

  final int userId;

  final Key? key;

  @override
  String toString() {
    return 'UserProfileRouteArgs{userId: $userId, key: $key}';
  }
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
    required int storeId,
    Key? key,
  }) : super(
          DetailsStoreRoute.name,
          path: 'details-store-screen',
          args: DetailsStoreRouteArgs(
            storeId: storeId,
            key: key,
          ),
        );

  static const String name = 'DetailsStoreRoute';
}

class DetailsStoreRouteArgs {
  const DetailsStoreRouteArgs({
    required this.storeId,
    this.key,
  });

  final int storeId;

  final Key? key;

  @override
  String toString() {
    return 'DetailsStoreRouteArgs{storeId: $storeId, key: $key}';
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
    required int id,
    Key? key,
  }) : super(
          DetailsAdRoute.name,
          path: 'details-ad-screen',
          args: DetailsAdRouteArgs(
            id: id,
            key: key,
          ),
        );

  static const String name = 'DetailsAdRoute';
}

class DetailsAdRouteArgs {
  const DetailsAdRouteArgs({
    required this.id,
    this.key,
  });

  final int id;

  final Key? key;

  @override
  String toString() {
    return 'DetailsAdRouteArgs{id: $id, key: $key}';
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
/// [ChangeExecutorScreen]
class ChangeExecutorRoute extends PageRouteInfo<void> {
  const ChangeExecutorRoute()
      : super(
          ChangeExecutorRoute.name,
          path: 'change-executor-screen',
        );

  static const String name = 'ChangeExecutorRoute';
}

/// generated route for
/// [ChangeStoreScreen]
class ChangeStoreRoute extends PageRouteInfo<void> {
  const ChangeStoreRoute()
      : super(
          ChangeStoreRoute.name,
          path: 'change-store-screen',
        );

  static const String name = 'ChangeStoreRoute';
}

/// generated route for
/// [ListChatsScreen]
class ListChatsRoute extends PageRouteInfo<void> {
  const ListChatsRoute()
      : super(
          ListChatsRoute.name,
          path: 'list-chats-screen',
        );

  static const String name = 'ListChatsRoute';
}

/// generated route for
/// [MyReviewsScreen]
class MyReviewsRoute extends PageRouteInfo<void> {
  const MyReviewsRoute()
      : super(
          MyReviewsRoute.name,
          path: 'my-reviews-screen',
        );

  static const String name = 'MyReviewsRoute';
}

/// generated route for
/// [StoreMyReviewsScreen]
class StoreMyReviewsRoute extends PageRouteInfo<StoreMyReviewsRouteArgs> {
  StoreMyReviewsRoute({
    required int storeId,
    Key? key,
  }) : super(
          StoreMyReviewsRoute.name,
          path: 'store-my-reviews-screen',
          args: StoreMyReviewsRouteArgs(
            storeId: storeId,
            key: key,
          ),
        );

  static const String name = 'StoreMyReviewsRoute';
}

class StoreMyReviewsRouteArgs {
  const StoreMyReviewsRouteArgs({
    required this.storeId,
    this.key,
  });

  final int storeId;

  final Key? key;

  @override
  String toString() {
    return 'StoreMyReviewsRouteArgs{storeId: $storeId, key: $key}';
  }
}

/// generated route for
/// [AboutScreen]
class AboutRoute extends PageRouteInfo<void> {
  const AboutRoute()
      : super(
          AboutRoute.name,
          path: 'about-screen',
        );

  static const String name = 'AboutRoute';
}
