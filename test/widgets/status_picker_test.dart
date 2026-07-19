import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/form/picker/status_picker.dart';

void main() {
  const all = [
    OrderStatus.active,
    OrderStatus.hasExecutor,
    OrderStatus.completed,
  ];

  group('StatusPickerController.seedFrom', () {
    test('returns null (All) when current equals the full set', () {
      expect(StatusPickerController.seedFrom(all, all), isNull);
    });

    test('ignores order when comparing to the full set', () {
      expect(
        StatusPickerController.seedFrom(
            const [
              OrderStatus.completed,
              OrderStatus.active,
              OrderStatus.hasExecutor,
            ],
            all),
        isNull,
      );
    });

    test('returns the single status when exactly one is selected', () {
      expect(
        StatusPickerController.seedFrom(const [OrderStatus.hasExecutor], all),
        OrderStatus.hasExecutor,
      );
    });

    test('returns null (All) for an arbitrary multi-status subset', () {
      expect(
        StatusPickerController.seedFrom(
            const [OrderStatus.active, OrderStatus.completed], all),
        isNull,
      );
    });
  });

  group('StatusPickerController.resolve', () {
    test('null resolves to the full set', () {
      expect(StatusPickerController.resolve(null, all), all);
    });

    test('a value resolves to a single-element list', () {
      expect(
        StatusPickerController.resolve(OrderStatus.archive, all),
        const [OrderStatus.archive],
      );
    });
  });

  testWidgets('StatusPicker shows the seeded status label', (tester) async {
    final controller = StatusPickerController(OrderStatus.hasExecutor);
    addTearDown(controller.dispose);

    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: StatusPicker(
          label: 'Status',
          controller: controller,
          options: all,
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Status'), findsOneWidget);
    expect(find.text('In work'), findsOneWidget);
  });
}
