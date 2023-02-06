import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/logic/form/project/create_update/create_update_project_cubit.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/get.dart';
// import 'generated/locale_keys.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');

  initializeGetIt();
  // Isar isar = await Isar.open([]);

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      darkTheme: themeDark,
      themeMode: ThemeMode.system,
    );
  }
}
