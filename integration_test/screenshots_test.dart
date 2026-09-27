// Обход экранов для скриншотов сайта. Нужен бэкенд с DemoSeeder
// (megaladon_back/database/seeders/DemoSeeder.php) и BASE_URL на него в .env.
// Сам тест только открывает экраны и печатает «SHOT:<имя>», снимает хост:
//   megaladon_app/integration_test/screenshots.sh
import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/locale_storage/secure_locale_storage.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/firebase_options.dart';
import 'package:megaladon/main.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/screens/splash_screen.dart';
import 'package:megaladon/presentation/widgets/card/chat_card.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('screenshots', (tester) async {
    await dotenv.load(fileName: '.env');
    await initializeGetIt();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    ApiService.initialize();

    final auth = AuthRepository(localeStorage: SecureLocaleStorageImpl());
    await auth.write(await auth.login(phone: '+77010000001', password: 'demo12345'));
    await IsFirstRun.isFirstCall(); // гасим онбординг

    runApp(App());
    await _wait(tester, 8);
    final router = AutoRouter.of(tester.element(find.byType(SplashScreen)));

    Future<void> shot(String name, PageRouteInfo route) async {
      router.navigate(route);
      await _wait(tester, 4);
      // ignore: avoid_print
      print('SHOT:$name');
      await _wait(tester, 3);
    }

    await shot('orders', const InitialRouter(children: [OrderRouter(children: [ListOrdersRoute()])]));
    await shot('order', InitialRouter(children: [OrderRouter(children: [DetailsOrderRoute(orderId: 1)])]));
    await shot('offers', InitialRouter(children: [OrderRouter(children: [ListExecutorsRoute(orderId: 1)])]));
    await shot('executor', InitialRouter(children: [OrderRouter(children: [DetailsExecutorRoute(executorId: 1)])]));
    await shot('stores', const InitialRouter(children: [StoreRouter(children: [ListStoresRoute()])]));
    await shot('ads', const InitialRouter(children: [AdRouter(children: [TradingAdsRoute()])]));
    await shot('chats', const InitialRouter(children: [ProfileRouter(children: [ListChatsRoute()])]));

    await tester.tap(find.byType(ChatCard).first);
    await _wait(tester, 4);
    // ignore: avoid_print
    print('SHOT:chat');
    await _wait(tester, 3);
  });
}

Future<void> _wait(WidgetTester tester, int seconds) async {
  for (var i = 0; i < seconds * 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
