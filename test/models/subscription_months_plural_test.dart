import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

void main() {
  test('срок подписки склоняется по-русски', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('ru'));

    expect(l10n.months_count(1), '1 месяц');
    expect(l10n.months_count(2), '2 месяца');
    expect(l10n.months_count(5), '5 месяцев');
    expect(l10n.months_count(11), '11 месяцев');
    expect(l10n.months_count(21), '21 месяц');

    expect(l10n.subscribed_for_months(1), 'Вы взяли подписку на 1 месяц');
    expect(l10n.subscribed_for_months(3), 'Вы взяли подписку на 3 месяца');
    expect(l10n.subscribed_for_months(6), 'Вы взяли подписку на 6 месяцев');
  });

  test('английская форма различает единственное и множественное', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    expect(l10n.months_count(1), '1 month');
    expect(l10n.months_count(6), '6 months');
    expect(l10n.subscribed_for_months(1), 'You subscribed for 1 month');
  });

  test('казахская форма не меняется по числу', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('kk'));

    expect(l10n.months_count(1), '1 ай');
    expect(l10n.months_count(6), '6 ай');
  });
}
