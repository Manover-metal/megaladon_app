import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

void main() {
  test('OrderStatus.localize returns localized labels (en)', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(OrderStatus.moderate.localize(l10n), 'On moderation');
    expect(OrderStatus.active.localize(l10n), 'Active');
    expect(OrderStatus.hasExecutor.localize(l10n), 'In work');
    expect(OrderStatus.completed.localize(l10n), 'Completed');
    expect(OrderStatus.archive.localize(l10n), 'Archive');
    expect(OrderStatus.nothing.localize(l10n), 'All');
  });
}
