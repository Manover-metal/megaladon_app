import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:megaladon/data/repositories/auth/log_repository.dart';

GetIt getItApp = GetIt.instance;

Future<void> initializeGetIt() async {
  getItApp.registerLazySingletonAsync<TelegramLogerRepository>(
      () async => await TelegramLogerRepository.initialize());
  getItApp
      .registerSingleton<GlobalKey<ScaffoldState>>(GlobalKey<ScaffoldState>());
}
