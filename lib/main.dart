import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/isar/index.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/firebase_options.dart';
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
import 'package:megaladon/logic/register/register_executor/register_executor_bloc.dart';
import 'package:megaladon/logic/register/register_store/register_store_bloc.dart';
import 'package:megaladon/logic/register/register_user/register_user_bloc.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/chats/chat_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/executors/my/executor_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/offers/details/offer_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/offers/list/offer_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_executor/change_executor_bloc.dart';
import 'package:megaladon/logic/screens/profile/change_photo/change_photo_cubit.dart';
import 'package:megaladon/logic/screens/profile/change_store/change_store_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';
import 'package:megaladon/logic/screens/store/details/store_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/presentation/routing/guards/auth_guard.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/get.dart';
import 'generated/codegen_loader.g.dart';
import 'logic/screens/advert/main/advert_screen_main_cubit.dart';

// import 'generated/locale_keys.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  initializeGetIt();
  await IsarService.initialize();
  ApiService.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    EasyLocalization(
      assetLoader: const CodegenLoader(),
      supportedLocales: const [
        Locale('en'),
        Locale('ru')
      ],
      path: 'assets/translations',
      startLocale: const Locale('ru'),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  final RegisterExecutorBloc registerExecutorBloc = RegisterExecutorBloc();
  final RegisterStoreBloc registerStoreBloc = RegisterStoreBloc();
  late AuthBloc authBloc = AuthBloc(registerStoreBloc, registerExecutorBloc)..add(AuthInitialEvent());
  late ProfileScreenCubit profileCubit = ProfileScreenCubit(authBloc);
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
            BlocProvider<AuthFormCubit>(
                create: (context) => AuthFormCubit()
            ),
            BlocProvider<RegisterUserFormCubit>(
                create: (context) => RegisterUserFormCubit()
            ),
            BlocProvider<RegisterStoreFormCubit>(
                create: (context) => RegisterStoreFormCubit()
            ),
            BlocProvider<RegisterExecutorFormCubit>(
                create: (context) => RegisterExecutorFormCubit()
            ),
            BlocProvider<VerifyFormCubit>(
                create: (context) => VerifyFormCubit()
            ),
            BlocProvider<AdvertScreenMainCubit>(
                create: (context) => AdvertScreenMainCubit()
            ),
            BlocProvider<AdvertScreenMyCubit>(
                create: (context) => AdvertScreenMyCubit()
            ),
            BlocProvider<OrderScreenMainCubit>(
                create: (context) => OrderScreenMainCubit()
            ),
            BlocProvider<ExecutorScreenMyCubit>(
                create: (context) => ExecutorScreenMyCubit()
            ),
            BlocProvider<ProfileScreenCubit>(
                create: (context) => profileCubit,
            ),
            BlocProvider<OrderScreenMyCubit>(
                create: (context) => OrderScreenMyCubit()
            ),
            BlocProvider<OrderScreenDetailsCubit>(
                create: (context) => OrderScreenDetailsCubit()
            ),
            BlocProvider<AdvertScreenDetailsCubit>(
                create: (context) => AdvertScreenDetailsCubit()
            ),
            BlocProvider<StoreScreenMainCubit>(
                create: (context) => StoreScreenMainCubit()
            ),
            BlocProvider<StoreScreenDetailsCubit>(
                create: (context) => StoreScreenDetailsCubit()
            ),
            BlocProvider<OfferScreenMainCubit>(
                create: (context) => OfferScreenMainCubit()
            ),
            BlocProvider<OfferScreenDetailsCubit>(
                create: (context) => OfferScreenDetailsCubit()
            ),
            BlocProvider<DictionaryCubit>(
                lazy: false,
                create: (context) => DictionaryCubit()..initial()
            ),
            BlocProvider<AdCreateFormCubit>(
                create: (context) => AdCreateFormCubit()
            ),
            BlocProvider<OrderCreateFormCubit>(
                create: (context) => OrderCreateFormCubit()
            ),
            BlocProvider<CreateOfferFormCubit>(
                create: (context) => CreateOfferFormCubit()
            ),
            BlocProvider<AdUpdateFormCubit>(
                create: (context) => AdUpdateFormCubit()
            ),
            BlocProvider<OrderUpdateFormCubit>(
                create: (context) => OrderUpdateFormCubit()
            ),
            BlocProvider<ChatScreenMainCubit>(
                create: (context) => ChatScreenMainCubit()
            )
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<PriceFormCubit>(
                  create: (context) => PriceFormCubit(profileCubit),
              ),
              BlocProvider<ChangePhotoCubit>(
                create: (context) => ChangePhotoCubit(profileCubit),
              ),
              BlocProvider<ChangeExecutorBloc>(
                create: (context) => ChangeExecutorBloc(profileCubit),
              ),
              BlocProvider<ChangeExecutorFormCubit>(
                create: (context) => ChangeExecutorFormCubit(),
              ),
              BlocProvider<ChangeStoreBloc>(
                create: (context) => ChangeStoreBloc(profileCubit),
              ),
              BlocProvider<ChangeStoreFormCubit>(
                create: (context) => ChangeStoreFormCubit(),
              ),
            ],
            child: const AppState(),
          ),
        ),
      ),
    );
  }
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
        notAuthGuard: NotAuthGuard(context),
        authGuard: AuthGuard(context)
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        final data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: min(maxPossibleTsf, data.textScaleFactor),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      darkTheme: themeDark,
      themeMode: ThemeMode.dark,
    );
  }
}
