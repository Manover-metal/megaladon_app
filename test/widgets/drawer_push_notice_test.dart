import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/repositories/notification_repository.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/settings/push_notification_cubit.dart';
import 'package:megaladon/presentation/widgets/drawer/drawer_push_notice.dart';
import 'package:megaladon/presentation/widgets/notifications/push_disabled_detector.dart';

/// Серверный флаг подменяем целиком: сеть в виджет-тестах не нужна, а
/// PushNotificationCubit уже умеет принимать репозиторий снаружи.
class _FakeRepo extends NotificationRepository {
  _FakeRepo({required this.enabled});
  final bool enabled;

  @override
  Future<bool> getPushStatus() async => enabled;
}

Widget _app({
  required PushSystemStatus system,
  required bool serverEnabled,
}) =>
    MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: DrawerPushNotice(
          probe: () async => system,
          cubitFactory: () => PushNotificationCubit(
              repository: _FakeRepo(enabled: serverEnabled)),
        ),
      ),
    );

Future<AppLocalizations> _ru() =>
    AppLocalizations.delegate.load(const Locale('ru'));

void main() {
  testWidgets('всё включено — уведомления в меню нет', (tester) async {
    await tester.pumpWidget(
      _app(system: PushSystemStatus.granted, serverEnabled: true),
    );
    await tester.pumpAndSettle();

    final l10n = await _ru();
    expect(find.text(l10n.pushBannerTitle), findsNothing);
  });

  // Пока не знаем системный статус — молчим, иначе плашка мигает при каждом
  // открытии меню.
  testWidgets('статус ещё не известен — уведомления нет', (tester) async {
    await tester.pumpWidget(
      _app(system: PushSystemStatus.unknown, serverEnabled: true),
    );
    await tester.pumpAndSettle();

    final l10n = await _ru();
    expect(find.text(l10n.pushBannerTitle), findsNothing);
  });

  testWidgets('запрещены в системе — ведёт в настройки телефона',
      (tester) async {
    await tester.pumpWidget(
      _app(system: PushSystemStatus.denied, serverEnabled: true),
    );
    await tester.pumpAndSettle();

    final l10n = await _ru();
    expect(find.text(l10n.pushBannerTitle), findsOneWidget);
    expect(find.text(l10n.pushBannerOpenSettings), findsOneWidget);
  });

  testWidgets('разрешение ещё не спрашивали — предлагаем разрешить',
      (tester) async {
    await tester.pumpWidget(
      _app(system: PushSystemStatus.notAsked, serverEnabled: true),
    );
    await tester.pumpAndSettle();

    final l10n = await _ru();
    expect(find.text(l10n.pushBannerAllow), findsOneWidget);
  });

  // Системное разрешение есть, но выключен серверный флаг — тот же, что
  // переключателем в настройках приложения.
  testWidgets('выключены в приложении — предлагаем включить', (tester) async {
    await tester.pumpWidget(
      _app(system: PushSystemStatus.granted, serverEnabled: false),
    );
    await tester.pumpAndSettle();

    final l10n = await _ru();
    expect(find.text(l10n.pushBannerTitle), findsOneWidget);
    expect(find.text(l10n.pushBannerEnable), findsOneWidget);
  });

  // Системный запрет перебивает серверный флаг: включать его бессмысленно,
  // пуш всё равно не покажется.
  testWidgets('выключены и там и там — сначала системные настройки',
      (tester) async {
    await tester.pumpWidget(
      _app(system: PushSystemStatus.denied, serverEnabled: false),
    );
    await tester.pumpAndSettle();

    final l10n = await _ru();
    expect(find.text(l10n.pushBannerOpenSettings), findsOneWidget);
    expect(find.text(l10n.pushBannerEnable), findsNothing);
  });

  // Плашка в меню — одна строка: заголовок и действие. Длинного пояснения
  // из профиля здесь быть не должно, оно раздувает меню.
  testWidgets('в меню только заголовок и действие, без пояснения',
      (tester) async {
    await tester.pumpWidget(
      _app(system: PushSystemStatus.granted, serverEnabled: false),
    );
    await tester.pumpAndSettle();

    final l10n = await _ru();
    expect(find.text(l10n.pushBannerText), findsNothing);
  });
}
