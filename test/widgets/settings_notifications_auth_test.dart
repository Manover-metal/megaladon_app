import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/locale/locale_cubit.dart';
import 'package:megaladon/logic/theme/theme_cubit.dart';
import 'package:megaladon/presentation/screens/profile/settings_screen.dart';

class _Storage extends LocaleStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async =>
      values[key] = value;

  @override
  Future<bool?> getBool(String key) async => null;

  @override
  Future<void> setBool(String key, bool value) async {}

  @override
  Future<void> remove(String key) async => values.remove(key);
}

void main() {
  setUpAll(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
    getItApp.registerSingleton<LocaleStorage>(_Storage());
  });

  Future<void> pump(WidgetTester tester, {required bool loggedIn}) async {
    final storage = _Storage();
    if (loggedIn) {
      storage.values['auth'] = jsonEncode(
          AuthModel(token: '1|t', refreshToken: 'r').toJson());
    }
    final auth = AuthBloc(
      authRepository: AuthRepository(localeStorage: storage),
      fcmTokenReader: () async => null,
    )..add(AuthInitialEvent());

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider.value(value: auth),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: const MaterialApp(
        locale: Locale('ru'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(),
      ),
    ));
    await tester.pump(const Duration(milliseconds: 100));
  }

  // SectionTitle выводит заголовок капсом.
  testWidgets('гостю блок уведомлений не показывается', (tester) async {
    await pump(tester, loggedIn: false);
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));
    expect(find.text(l10n.settingsGroupNotifications.toUpperCase()), findsNothing);
    expect(find.text(l10n.settingsGroupAppearance.toUpperCase()), findsOneWidget);
  });

  testWidgets('авторизованному блок уведомлений показывается', (tester) async {
    await pump(tester, loggedIn: true);
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));
    expect(find.text(l10n.settingsGroupNotifications.toUpperCase()), findsOneWidget);
  });
}
