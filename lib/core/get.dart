import 'package:get_it/get_it.dart';
import 'package:megaladon/data/repositories/log_repository.dart';

GetIt getItApp = GetIt.instance;

initializeGetIt() async{
  getItApp.registerLazySingletonAsync<TelegramLogerRepository>(() async => await TelegramLogerRepository.initialize());
}