import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/fb_notification/index.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/isar/index.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/data/repositories/review_repository.dart';
import 'package:megaladon/firebase_options.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/logic/form/auth/auth_form_cubit.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/logic/form/create/offer/create_offer_form_cubit.dart';
import 'package:megaladon/logic/form/create/order/order_create_form_cubit.dart';
import 'package:megaladon/logic/form/price/price_form_cubit.dart';
import 'package:megaladon/logic/form/register/register_executor/register_executor_form_cubit.dart';
import 'package:megaladon/logic/form/register/register_store/register_store_form_cubit.dart';
import 'package:megaladon/logic/form/register/register_user/register_user_form_cubit.dart';
import 'package:megaladon/logic/form/update/ad/ad_update_form_cubit.dart';
import 'package:megaladon/logic/form/update/executor/change_executor_form_cubit.dart';
import 'package:megaladon/logic/form/update/order/order_update_form_cubit.dart';
import 'package:megaladon/logic/form/update/store/change_store_form_cubit.dart';
import 'package:megaladon/logic/form/verify/verify_form_cubit.dart';
import 'package:megaladon/logic/locale/locale_cubit.dart';
import 'package:megaladon/logic/register/register_executor/register_executor_bloc.dart';
import 'package:megaladon/logic/register/register_store/register_store_bloc.dart';
import 'package:megaladon/logic/register/register_user/register_user_bloc.dart';
import 'package:megaladon/logic/screens/advert/delete/advert_delete_cubit.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
// import 'generated/codegen_loader.g.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/chats/chat_cubit.dart';
import 'package:megaladon/logic/screens/executors/details/executor_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/executors/favorite/add_favorite_cubit.dart';
import 'package:megaladon/logic/screens/executors/my/executor_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/offers/details/offer_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/offers/list/offer_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/orders/delete/order_delete_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/orders/review/review_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_executor/change_executor_bloc.dart';
import 'package:megaladon/logic/screens/profile/change_password/change_password_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_phone/change_phone_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_photo/change_photo_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_store/change_store_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/logic/screens/store/details/store_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/store/rate/rate_store_cubit.dart';
import 'package:megaladon/logic/subscribe/subscribe_cubit.dart';
import 'package:megaladon/presentation/routing/guards/auth_guard.dart';
import 'package:megaladon/presentation/routing/router.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await dotenv.load(fileName: '.env');
  await initializeGetIt();

  await IsarService.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FbNotificationService.initialize();
  ApiService.initialize();

  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});
  final RegisterExecutorBloc registerExecutorBloc = RegisterExecutorBloc();
  final RegisterStoreBloc registerStoreBloc = RegisterStoreBloc();
  late AuthBloc authBloc = AuthBloc(registerStoreBloc, registerExecutorBloc)
    ..add(AuthInitialEvent());
  late ProfileScreenCubit profileCubit = ProfileScreenCubit(authBloc);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
          BlocProvider<RegisterExecutorBloc>(
            create: (context) => registerExecutorBloc,
          ),
          BlocProvider<RegisterStoreBloc>(
            create: (context) => registerStoreBloc,
          )
        ],
        child: BlocProvider<AuthBloc>(
          lazy: false,
          create: (context) => authBloc,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RegisterUserBloc>(
                create: (context) => RegisterUserBloc(),
              ),
              BlocProvider<AuthFormCubit>(create: (context) => AuthFormCubit()),
              BlocProvider<RegisterUserFormCubit>(
                  create: (context) => RegisterUserFormCubit()),
              BlocProvider<RegisterStoreFormCubit>(
                  create: (context) => RegisterStoreFormCubit()),
              BlocProvider<RegisterExecutorFormCubit>(
                  create: (context) => RegisterExecutorFormCubit()),
              BlocProvider<VerifyFormCubit>(
                  create: (context) => VerifyFormCubit()),
              BlocProvider<AdvertScreenMainCubit>(
                  create: (context) => AdvertScreenMainCubit()),
              BlocProvider<AdvertScreenMyCubit>(
                  create: (context) => AdvertScreenMyCubit(authBloc)),
              BlocProvider<OrderScreenMainCubit>(
                  create: (context) => OrderScreenMainCubit()),
              BlocProvider<ExecutorScreenMyCubit>(
                  create: (context) => ExecutorScreenMyCubit(authBloc)),
              BlocProvider<ProfileScreenCubit>(
                create: (context) => profileCubit,
              ),
              BlocProvider<OrderScreenMyCubit>(
                  create: (context) => OrderScreenMyCubit(authBloc)),
              BlocProvider<OrderScreenDetailsCubit>(
                  create: (context) => OrderScreenDetailsCubit()),
              BlocProvider<AdvertScreenDetailsCubit>(
                  create: (context) => AdvertScreenDetailsCubit()),
              BlocProvider<StoreScreenMainCubit>(
                  create: (context) => StoreScreenMainCubit()),
              BlocProvider<StoreScreenDetailsCubit>(
                  create: (context) => StoreScreenDetailsCubit()),
              BlocProvider<ExecutorScreenDetailsCubit>(
                  create: (context) => ExecutorScreenDetailsCubit()),
              BlocProvider<OfferScreenMainCubit>(
                  create: (context) => OfferScreenMainCubit()),
              BlocProvider<OfferScreenDetailsCubit>(
                  create: (context) => OfferScreenDetailsCubit()),
              BlocProvider<DictionaryCubit>(
                  lazy: false,
                  create: (context) => DictionaryCubit()..initial()),
              BlocProvider<AdCreateFormCubit>(
                  create: (context) => AdCreateFormCubit(authBloc)),
              BlocProvider<OrderCreateFormCubit>(
                  create: (context) => OrderCreateFormCubit(authBloc)),
              BlocProvider<CreateOfferFormCubit>(
                  create: (context) => CreateOfferFormCubit(authBloc)),
              BlocProvider<AdUpdateFormCubit>(
                  create: (context) => AdUpdateFormCubit(authBloc)),
              BlocProvider<OrderUpdateFormCubit>(
                  create: (context) => OrderUpdateFormCubit(authBloc)),
              BlocProvider<ChatCubit>(
                  lazy: false, create: (context) => ChatCubit(authBloc)),
              BlocProvider<SubscribeCubit>(
                  create: (context) => SubscribeCubit()),
              BlocProvider<ReviewCubit>(
                  create: (context) => ReviewCubit(ReviewRepository())),
              BlocProvider<OrderDeleteCubit>(
                  create: (context) => OrderDeleteCubit()),
              BlocProvider<AddFavoriteCubit>(
                  create: (context) => AddFavoriteCubit()),
              BlocProvider<RateStoreCubit>(
                  create: (context) => RateStoreCubit()),
              BlocProvider<AdvertDeleteCubit>(
                  create: (context) => AdvertDeleteCubit()),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<PriceFormCubit>(
                  create: (context) => PriceFormCubit(profileCubit, authBloc),
                ),
                BlocProvider<ChangePhotoCubit>(
                  create: (context) => ChangePhotoCubit(profileCubit, authBloc),
                ),
                BlocProvider<ChangeExecutorBloc>(
                  create: (context) =>
                      ChangeExecutorBloc(profileCubit, authBloc),
                ),
                BlocProvider<ChangeExecutorFormCubit>(
                  create: (context) => ChangeExecutorFormCubit(),
                ),
                BlocProvider<ChangeStoreBloc>(
                  create: (context) => ChangeStoreBloc(profileCubit, authBloc),
                ),
                BlocProvider<ChangeStoreFormCubit>(
                  create: (context) => ChangeStoreFormCubit(),
                ),
                BlocProvider<ChangePasswordCubit>(
                  create: (context) => ChangePasswordCubit(authBloc),
                ),
                BlocProvider<ChangePhoneCubit>(
                  create: (context) => ChangePhoneCubit(profileCubit, authBloc),
                ),
              ],
              child: const AppState(),
            ),
          ),
        ),
      );
}

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  late AppRouter _appRouter;
  final maxPossibleTsf = 1.1;

  @override
  void initState() {
    _appRouter = AppRouter(
        notAuthGuard: NotAuthGuard(context), authGuard: AuthGuard(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) => MaterialApp.router(
          locale: locale,
          builder: (context, child) {
            final data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(textScaler: const TextScaler.linear(1)),
              child: child ?? const SizedBox.shrink(),
            );
          },
          debugShowCheckedModeBanner: false,
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          darkTheme: themeDark,
          themeMode: ThemeMode.dark,
        ),
      );
}
