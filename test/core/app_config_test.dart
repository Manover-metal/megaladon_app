import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/app_config.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/models/executor_model.dart';

class _Storage extends LocaleStorage {
  final Map<String, bool> bools = {};
  @override
  Future<String?> getString(String key) async => null;
  @override
  Future<void> setString(String key, String value) async {}
  @override
  Future<bool?> getBool(String key) async => bools[key];
  @override
  Future<void> setBool(String key, bool value) async => bools[key] = value;
  @override
  Future<void> remove(String key) async => bools.remove(key);
}

class _Server implements HttpClientAdapter {
  bool? enabled; // null — сети нет
  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? s,
      Future<void>? c) async {
    if (enabled == null) {
      throw DioException.connectionError(requestOptions: o, reason: 'offline');
    }
    return ResponseBody.fromString(
        jsonEncode({'subscriptions_enabled': enabled}), 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType]
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final storage = _Storage();
  final server = _Server();

  setUpAll(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
    ApiService.I.httpClientAdapter = server;
    getItApp.registerSingleton<LocaleStorage>(storage);
  });

  setUp(() {
    storage.bools.clear();
    AppConfig.subscriptionsEnabled.value = false;
  });

  test('первый запуск: подписки скрыты, ответ сервера запоминается', () async {
    server.enabled = true;
    await AppConfig.init();
    expect(AppConfig.subscriptionsEnabled.value, isFalse);

    await pumpEventQueue();
    expect(AppConfig.subscriptionsEnabled.value, isTrue);
    expect(storage.bools.values, [true]);
  });

  test('без сети остаётся значение прошлого запуска', () async {
    server.enabled = true;
    await AppConfig.refresh();
    server.enabled = null;
    AppConfig.subscriptionsEnabled.value = false;

    await AppConfig.init();
    await pumpEventQueue();
    expect(AppConfig.subscriptionsEnabled.value, isTrue);
  });

  test('подписки выключены — у исполнителя без подписки доступ открыт', () {
    final executor = ExecutorModel(id: 1, name: 'МеталлПро');
    final expired = ExecutorModel(
        id: 1,
        name: 'МеталлПро',
        subscriptionExpiredAt: DateTime.now().subtract(const Duration(days: 1)));

    AppConfig.subscriptionsEnabled.value = false;
    expect(executor.hasActiveSubscription, isTrue);
    expect(expired.hasActiveSubscription, isTrue);

    AppConfig.subscriptionsEnabled.value = true;
    expect(executor.hasActiveSubscription, isFalse);
    expect(expired.hasActiveSubscription, isFalse);
  });

  testWidgets('SubscriptionsVisible прячет и показывает без перезапуска',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: SubscriptionsVisible(child: Text('Подписки'))));
    expect(find.text('Подписки'), findsNothing);

    AppConfig.subscriptionsEnabled.value = true;
    await tester.pump();
    expect(find.text('Подписки'), findsOneWidget);

    AppConfig.subscriptionsEnabled.value = false;
    await tester.pump();
    expect(find.text('Подписки'), findsNothing);
  });
}
