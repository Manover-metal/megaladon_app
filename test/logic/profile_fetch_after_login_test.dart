import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/models/user_model.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/data/repositories/user_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/profile/profile_screen_cubit.dart';

class _MemoryStorage extends LocaleStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async => values[key] = value;

  @override
  Future<bool?> getBool(String key) async => null;

  @override
  Future<void> setBool(String key, bool value) async {}

  @override
  Future<void> remove(String key) async => values.remove(key);
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository() : super(localeStorage: _MemoryStorage());

  @override
  Future<AuthModel> login({
    required String phone,
    required String password,
  }) async =>
      AuthModel(token: '23|token');

  @override
  Future<void> sendFB({required String token}) async {}
}

class _Harness {
  _Harness(this.authBloc, this.users);
  final AuthBloc authBloc;
  final _CountingUserRepository users;
}

/// Считает обращения за профилем — именно их должен порождать вход.
class _CountingUserRepository extends UserRepository {
  int profileCalls = 0;

  @override
  Future<UserModel> profile() async {
    profileCalls++;
    return UserModel(
      id: 1,
      name: 'Иван',
      countOrders: 0,
      phone: '+77001112233',
      photo: null,
      city: null,
      executor: null,
      store: null,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Нужен только как держатель токена: AuthRepository.write() кладёт токен
    // в статический AuthInterceptor. Сетевых запросов тест не делает.
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
  });

  /// Повторяет проводку из main.dart: AuthBloc создаётся сразу (lazy: false),
  /// ProfileScreenCubit — через BlocProvider.
  ///
  /// Потомок изображает то, что видит гость: экран, который ProfileScreenCubit
  /// не читает. В приложении это DrawerApp с _GuestHeader — у гостя все ветки
  /// с BlocBuilder<ProfileScreenCubit> спрятаны за `authState is AuthLoginState`.
  Future<_Harness> pumpGuestApp(
    WidgetTester tester, {
    required bool lazyProfile,
  }) async {
    final authBloc = AuthBloc(
      authRepository: _FakeAuthRepository(),
      fcmTokenReader: () async => null,
    );
    final users = _CountingUserRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>(
          lazy: false,
          create: (_) => authBloc,
          child: BlocProvider<ProfileScreenCubit>(
            lazy: lazyProfile,
            create: (_) => ProfileScreenCubit(authBloc, repository: users),
            child: const Scaffold(body: Text('гость')),
          ),
        ),
      ),
    );

    return _Harness(authBloc, users);
  }

  /// Логинимся и даём отработать асинхронным цепочкам bloc-а.
  ///
  /// runAsync обязателен: тело testWidgets крутится в FakeAsync, где обычный
  /// await на Future репозитория не продолжится, а pumpAndSettle на дереве без
  /// анимаций просто виснет.
  Future<void> login(WidgetTester tester, AuthBloc authBloc) async {
    await tester.runAsync(() async {
      authBloc.add(const AuthLoginEvent('+77001112233', 'secret'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
  }

  testWidgets(
      'вход загружает профиль, хотя ни один видимый экран cubit ещё не читал',
      (tester) async {
    final harness = await pumpGuestApp(tester, lazyProfile: false);

    await login(tester, harness.authBloc);

    expect(harness.authBloc.state, isA<AuthLoginState>(),
        reason: 'вход должен был пройти');
    expect(
      harness.users.profileCalls,
      greaterThan(0),
      reason: 'AuthLoginState обязан запустить загрузку профиля: шапка '
          'DrawerApp рисуется из ProfileScreenCubit сразу после входа',
    );
  });

  testWidgets(
      'ленивый провайдер теряет событие входа — почему нужен lazy: false',
      (tester) async {
    // Характеризующий тест: фиксирует причину, по которой в main.dart у
    // BlocProvider<ProfileScreenCubit> стоит lazy: false. Ленивый провайдер не
    // создаёт cubit до первого context.read, поэтому подписки на
    // authBloc.stream в момент AuthLoginState не существует и fetch() не
    // вызывается — данные появлялись только когда ProfileScreen впервые читал
    // cubit из context.
    final harness = await pumpGuestApp(tester, lazyProfile: true);

    await login(tester, harness.authBloc);

    expect(harness.users.profileCalls, 0);
  });
}
