import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';

/// Экраны табов рисуют собственный Scaffold внутри Scaffold с drawer'ом
/// (его держит AutoTabsScaffold в SplashScreen). Кнопка «меню» обязана
/// открывать именно внешний.
Widget _screenWithDrawer({Key? outerKey}) => Scaffold(
      key: outerKey,
      drawer: const Drawer(child: Text('drawer content')),
      body: const Scaffold(
        appBar: HeaderAppBar(isMenu: true, title: 'Заказы'),
        body: SizedBox.shrink(),
      ),
    );

void main() {
  testWidgets('кнопка меню открывает drawer внешнего Scaffold', (tester) async {
    await tester.pumpWidget(MaterialApp(home: _screenWithDrawer()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('drawer content'), findsOneWidget);
  });

  // Во время replaceAll старая и новая страницы живут в дереве одновременно,
  // поэтому экран с drawer'ом существует в двух экземплярах. Общий
  // GlobalKey<ScaffoldState> на оба ронял дерево с «Multiple widgets used the
  // same GlobalKey».
  testWidgets('две копии экрана сосуществуют в дереве', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Stack(
        children: [
          _screenWithDrawer(),
          _screenWithDrawer(),
        ],
      ),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
