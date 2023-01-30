import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:megaladon/data/repositories/log_repository.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_app.dart';

GetIt getItApp = GetIt.instance;

initializeGetIt() async{
  getItApp.registerLazySingletonAsync<TelegramLogerRepository>(() async => await TelegramLogerRepository.initialize());
  getItApp.registerSingleton<GlobalKey<ScaffoldState>>(GlobalKey<ScaffoldState>());

}