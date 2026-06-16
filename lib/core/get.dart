import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/core/locale_storage/shared_locale_storage.dart';
import 'package:megaladon/data/repositories/auth/log_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getItApp = GetIt.instance;

Future<void> initializeGetIt() async {
  getItApp.registerLazySingletonAsync<TelegramLogerRepository>(
      () async => await TelegramLogerRepository.initialize());
  getItApp
      .registerSingleton<GlobalKey<ScaffoldState>>(GlobalKey<ScaffoldState>());

  final prefs = await SharedPreferences.getInstance();
  getItApp.registerSingleton<LocaleStorage>(LocaleStorageImpl(prefs));
}
