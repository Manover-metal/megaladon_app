import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/isar/index.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';
import 'package:megaladon/logic/form/auth/auth_form_cubit.dart';
import 'package:megaladon/logic/form/create/ad/ad_create_form_cubit.dart';
import 'package:megaladon/logic/form/create/order/order_create_form_cubit.dart';
import 'package:megaladon/logic/form/register/register_user/register_user_form_cubit.dart';
import 'package:megaladon/logic/form/verify/verify_form_cubit.dart';
import 'package:megaladon/logic/register/register_user/register_user_bloc.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/orders/details/order_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/store/details/store_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/get.dart';
import 'logic/screens/advert/main/advert_screen_main_cubit.dart';
// import 'generated/locale_keys.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await IsarService.initialize();
  ApiService.initialize();
  initializeGetIt();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ru')
      ],
      path: 'assets/translations',
      startLocale: Locale('ru'),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthFormCubit>(
            create: (context) => AuthFormCubit()
        ),
        BlocProvider<RegisterUserFormCubit>(
            create: (context) => RegisterUserFormCubit()
        ),
        BlocProvider<VerifyFormCubit>(
            create: (context) => VerifyFormCubit()
        ),
        BlocProvider<AuthBloc>(
            lazy: false,
            create: (context) => AuthBloc()..add(AuthInitialEvent())
        ),
        BlocProvider<RegisterUserBloc>(
            create: (context) => RegisterUserBloc()
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
        BlocProvider<DictionaryCubit>(
            lazy: false,
            create: (context) => DictionaryCubit()..initial()
        ),
        BlocProvider<AdCreateFormCubit>(
            create: (context) => AdCreateFormCubit()
        ),
        BlocProvider<OrderCreateFormCubit>(
            create: (context) => OrderCreateFormCubit()
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        darkTheme: themeDark,
        themeMode: ThemeMode.dark,
      ),
    );
  }
}
