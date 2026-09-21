import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_test/flutter_test.dart';

/// Во время replaceAll старый и новый SplashScreen живут в дереве
/// одновременно (см. header_drawer_test). У каждого — свой Intro с четырьмя
/// IntroStepBuilder(order: 1..4). Ключ шага у flutter_intro строится как
/// GlobalStringKey('${group}_$order') и сравнивается по строке, поэтому два
/// экрана с одинаковыми group и order держат один и тот же GlobalKey — Flutter
/// роняет дерево с «Multiple widgets used the same GlobalKey».
Widget _shellWithIntro({String group = 'default'}) => Intro(
      child: Builder(
        builder: (context) => Column(
          children: [
            IntroStepBuilder(
              order: 1,
              group: group,
              builder: (context, key) =>
                  SizedBox(key: key, width: 10, height: 10),
              overlayBuilder: (_) => const Text('шаг'),
            ),
          ],
        ),
      ),
    );

void main() {
  testWidgets('две копии шелла с Intro в одной группе конфликтуют по ключу',
      (tester) async {
    // Ошибок приходит несколько за кадр (build + finalize), и takeException
    // отдаёт их обёрткой — собираем все сами.
    final errors = <String>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (details) => errors.add(details.exceptionAsString());
    addTearDown(() => FlutterError.onError = previous);

    await tester.pumpWidget(MaterialApp(
      home: Stack(children: [_shellWithIntro(), _shellWithIntro()]),
    ));
    await tester.pump();
    tester.takeException();

    expect(
      errors
          .where((e) => e.contains('Multiple widgets used the same GlobalKey')),
      isNotEmpty,
      reason: 'одинаковые group+order обязаны дать конфликт GlobalKey',
    );
  });

  testWidgets('две копии шелла с разными группами живут вместе',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Stack(children: [
        _shellWithIntro(group: 'a'),
        _shellWithIntro(group: 'b'),
      ]),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
