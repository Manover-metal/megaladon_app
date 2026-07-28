# Order Status Filter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let users filter order lists by status via a single-select "Status" section inside the existing filter bottom sheets, on both order-list screens.

**Architecture:** The backend and the `statuses` request param already support status filtering — this is UI + localization only. Add a localized label to the `OrderStatus` enum, a reusable single-select `StatusPicker` (CupertinoPicker, mirroring `IndexPeriodPicker`) whose "All" item maps to a screen-specific default set, and wire it into `FilterOrderBottomSheet` (public feed) and `FilterMyOrderBottomSheet` (my orders). All non-trivial logic lives in two pure static functions (`StatusPickerController.seedFrom` / `.resolve`) that are unit-tested; the sheet wiring is glue verified by `flutter analyze`.

**Tech Stack:** Flutter, `flutter_bloc` (Cubit), `auto_route`, Flutter gen-l10n (en/ru/kk `.arb`).

## Global Constraints

- Three locales must stay in sync: `lib/l10n/app_en.arb`, `app_ru.arb`, `app_kk.arb`. Every new key added to all three.
- State management is strictly `flutter_bloc` Cubits — no Riverpod, no new state libraries.
- No new dependencies.
- Follow the existing picker pattern (`lib/presentation/widgets/form/picker/last_day_picker.dart`) for any new picker widget.
- `OrderStatus` wire format is the enum index: `nothing=0, moderate=1, active=2, hasExecutor=3, completed=4, archive=5`. Do not reorder the enum.
- "All" sets differ per screen: public feed = `[active, hasExecutor, completed]`; my orders = `OrderStatus.values`. The `nothing` status is never an offered option.

---

### Task 1: Localized `OrderStatus` labels

**Files:**
- Modify: `lib/l10n/app_en.arb` (after the `"active"` entry, line ~53)
- Modify: `lib/l10n/app_ru.arb` (after the `"active"` entry, line ~34)
- Modify: `lib/l10n/app_kk.arb` (after the `"active"` entry, line ~34)
- Modify: `lib/data/models/order_model.dart:9` (the `OrderStatus` enum)
- Test: `test/models/order_status_localize_test.dart`

**Interfaces:**
- Produces: `String OrderStatus.localize(AppLocalizations l10n)` — returns the user-facing label for a status. Also new l10n keys: `status`, `moderate`, `completed` (reuses existing `active`, `in_work`, `archive`, `all`).

- [ ] **Step 1: Add the three new keys to all three `.arb` files**

In `lib/l10n/app_en.arb`, immediately after the line `"active": "Active",` add:

```json
  "moderate": "On moderation",
  "completed": "Completed",
  "status": "Status",
```

In `lib/l10n/app_ru.arb`, immediately after the line `"active": "Активные",` add:

```json
  "moderate": "На проверке",
  "completed": "Выполнен",
  "status": "Статус",
```

In `lib/l10n/app_kk.arb`, immediately after the line `"active": "Белсенді",` add:

```json
  "moderate": "Тексеруде",
  "completed": "Орындалды",
  "status": "Мәртебе",
```

- [ ] **Step 2: Regenerate localizations**

Run: `flutter gen-l10n`
Expected: exits 0; `lib/generated/l10n/app_localizations.dart` now declares `String get moderate;`, `String get completed;`, `String get status;`.

- [ ] **Step 3: Write the failing test**

Create `test/models/order_status_localize_test.dart`:

```dart
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
```

- [ ] **Step 4: Run the test to verify it fails**

Run: `flutter test test/models/order_status_localize_test.dart`
Expected: FAIL — `The method 'localize' isn't defined for the type 'OrderStatus'`.

- [ ] **Step 5: Convert `OrderStatus` to an enhanced enum with `localize`**

In `lib/data/models/order_model.dart`, add the import near the other imports (after line 7):

```dart
import 'package:megaladon/generated/l10n/app_localizations.dart';
```

Replace the enum at line 9:

```dart
enum OrderStatus { nothing, moderate, active, hasExecutor, completed, archive }
```

with:

```dart
enum OrderStatus {
  nothing,
  moderate,
  active,
  hasExecutor,
  completed,
  archive;

  String localize(AppLocalizations l10n) {
    switch (this) {
      case OrderStatus.moderate:
        return l10n.moderate;
      case OrderStatus.active:
        return l10n.active;
      case OrderStatus.hasExecutor:
        return l10n.in_work;
      case OrderStatus.completed:
        return l10n.completed;
      case OrderStatus.archive:
        return l10n.archive;
      case OrderStatus.nothing:
        return l10n.all;
    }
  }
}
```

- [ ] **Step 6: Run the test to verify it passes**

Run: `flutter test test/models/order_status_localize_test.dart`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/l10n/app_en.arb lib/l10n/app_ru.arb lib/l10n/app_kk.arb lib/generated/l10n lib/data/models/order_model.dart test/models/order_status_localize_test.dart
git commit -m "feat: localize OrderStatus labels"
```

---

### Task 2: `StatusPicker` widget + pure seed/resolve logic

**Files:**
- Create: `lib/presentation/widgets/form/picker/status_picker.dart`
- Test: `test/widgets/status_picker_test.dart`

**Interfaces:**
- Consumes: `OrderStatus.localize` (Task 1).
- Produces:
  - `class StatusPickerController extends ValueNotifier<OrderStatus?>` — `value == null` means "All".
  - `static OrderStatus? StatusPickerController.seedFrom(List<OrderStatus> current, List<OrderStatus> all)`
  - `static List<OrderStatus> StatusPickerController.resolve(OrderStatus? value, List<OrderStatus> all)`
  - `class StatusPicker extends StatefulWidget` with `{required String label, required StatusPickerController controller, required List<OrderStatus> options}`.

- [ ] **Step 1: Write the failing tests**

Create `test/widgets/status_picker_test.dart`:

```dart
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
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/widgets/status_picker_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '.../status_picker.dart'`.

- [ ] **Step 3: Implement the widget**

Create `lib/presentation/widgets/form/picker/status_picker.dart`:

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

class StatusPickerController extends ValueNotifier<OrderStatus?> {
  StatusPickerController(OrderStatus? status) : super(status);

  void _change(OrderStatus? status) {
    value = status;
    notifyListeners();
  }

  /// Seeds the picker from the params' current [statuses] list.
  /// Returns null ("All") when [current] matches [all] (order-insensitive) or
  /// is any other multi-status subset; returns the single status when exactly
  /// one concrete status is selected.
  static OrderStatus? seedFrom(
      List<OrderStatus> current, List<OrderStatus> all) {
    if (setEquals(current.toSet(), all.toSet())) return null;
    if (current.length == 1) return current.first;
    return null;
  }

  /// Resolves the picked value back into a params' [statuses] list.
  /// null ("All") -> a copy of the full [all] set; a value -> a single-element
  /// list.
  static List<OrderStatus> resolve(OrderStatus? value, List<OrderStatus> all) =>
      value == null ? List<OrderStatus>.from(all) : [value];
}

class StatusPicker extends StatefulWidget {
  const StatusPicker({
    required this.label,
    required this.controller,
    required this.options,
    super.key,
  });
  final String label;
  final StatusPickerController controller;

  /// Concrete statuses selectable on this screen. The "All" item is always
  /// shown first and is not part of this list.
  final List<OrderStatus> options;

  @override
  State<StatusPicker> createState() => _StatusPickerState();
}

class _StatusPickerState extends State<StatusPicker> {
  String _label(OrderStatus? status, AppLocalizations l10n) =>
      status == null ? l10n.all : status.localize(l10n);

  Future<void> _handleClick() async {
    final items = <OrderStatus?>[null, ...widget.options];
    var initialIndex = items.indexWhere((s) => s == widget.controller.value);
    if (initialIndex < 0) initialIndex = 0;
    var selectedIndex = initialIndex;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height / 3.5 + 44,
        color: Theme.of(ctx).colorScheme.surface,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                CupertinoButton(
                  child: Text(AppLocalizations.of(context)!.select),
                  onPressed: () {
                    widget.controller._change(items[selectedIndex]);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: initialIndex),
                itemExtent: 36,
                onSelectedItemChanged: (index) => selectedIndex = index,
                children: items
                    .map((s) => Center(
                        child: Text(_label(s, AppLocalizations.of(context)!))))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, status, child) => GestureDetector(
            onTap: _handleClick,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                            _label(status, AppLocalizations.of(context)!)),
                      ),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/widgets/status_picker_test.dart`
Expected: PASS (7 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/widgets/form/picker/status_picker.dart test/widgets/status_picker_test.dart
git commit -m "feat: add single-select StatusPicker widget"
```

---

### Task 3: Wire status filter into the public feed sheet (`FilterOrderBottomSheet`)

**Files:**
- Modify: `lib/presentation/widgets/bottom_sheet/filters/filter_order_bottom_sheet.dart`

**Interfaces:**
- Consumes: `StatusPicker`, `StatusPickerController.seedFrom`, `StatusPickerController.resolve` (Task 2); `OrderScreenMainCubit.state.params.statuses` and `changeParams`.
- "All" set for this screen: `[OrderStatus.active, OrderStatus.hasExecutor, OrderStatus.completed]` (the cubit's default).

- [ ] **Step 1: Add imports**

In `lib/presentation/widgets/bottom_sheet/filters/filter_order_bottom_sheet.dart`, add after the existing `last_day_picker.dart` import (line 9):

```dart
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/presentation/widgets/form/picker/status_picker.dart';
```

- [ ] **Step 2: Declare the options constant and the controller field**

Immediately after the class declaration line `class _FilterOrderBottomSheetState extends State<FilterOrderBottomSheet> {` add the constant:

```dart
  static const _statusOptions = [
    OrderStatus.active,
    OrderStatus.hasExecutor,
    OrderStatus.completed,
  ];
```

Then, alongside the other controller fields (after `late OrderCategoryPickerController _orderCategoryPickerController;`) add:

```dart
  late StatusPickerController _statusPickerController;
```

- [ ] **Step 3: Seed the controller in `initState`**

In `initState`, after the `_orderCategoryPickerController` is assigned, add:

```dart
    _statusPickerController = StatusPickerController(
        StatusPickerController.seedFrom(state.params.statuses, _statusOptions));
```

- [ ] **Step 4: Dispose the controller**

In `dispose`, before `super.dispose();`, add:

```dart
    _statusPickerController.dispose();
```

- [ ] **Step 5: Pass the resolved statuses in `_back`**

Replace the `changeParams` call in `_back` with one that also sets `statuses`:

```dart
    context.read<OrderScreenMainCubit>().changeParams(params.copyWithNull(
        startRow: 0,
        last: _indexPeriodPickerController.value,
        city: city,
        category: category,
        statuses: StatusPickerController.resolve(
            _statusPickerController.value, _statusOptions)));
```

- [ ] **Step 6: Add the `StatusPicker` to the layout**

In `build`, insert this `Row` immediately after the `IndexPeriodPicker` `Row` (the one ending at the `],` before `const SizedBox(height: 30)`):

```dart
            Row(
              children: [
                Expanded(
                  child: StatusPicker(
                    label: AppLocalizations.of(context)!.status,
                    controller: _statusPickerController,
                    options: _statusOptions,
                  ),
                )
              ],
            ),
```

- [ ] **Step 7: Verify it compiles and the suite is green**

Run: `flutter analyze lib/presentation/widgets/bottom_sheet/filters/filter_order_bottom_sheet.dart`
Expected: "No issues found!"

Run: `flutter test`
Expected: all tests pass (no regressions).

- [ ] **Step 8: Commit**

```bash
git add lib/presentation/widgets/bottom_sheet/filters/filter_order_bottom_sheet.dart
git commit -m "feat: status filter in the public order feed sheet"
```

---

### Task 4: Wire status filter into the my-orders sheet (`FilterMyOrderBottomSheet`)

**Files:**
- Modify: `lib/presentation/widgets/bottom_sheet/filters/filter_order_my_bottom_sheet.dart`

**Interfaces:**
- Consumes: `StatusPicker`, `StatusPickerController.seedFrom`, `StatusPickerController.resolve` (Task 2); `OrderScreenMyCubit.state.params.statuses` and `changeParams`.
- Offered options exclude `nothing`: `[moderate, active, hasExecutor, completed, archive]`. "All" set = `OrderStatus.values` (matches `OrderScreenMyState`'s default).

- [ ] **Step 1: Add imports**

In `lib/presentation/widgets/bottom_sheet/filters/filter_order_my_bottom_sheet.dart`, add after the existing `last_day_picker.dart` import (line 9):

```dart
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/presentation/widgets/form/picker/status_picker.dart';
```

- [ ] **Step 2: Declare the options/all constants and the controller field**

Immediately after `class _FilterMyOrderBottomSheetState extends State<FilterMyOrderBottomSheet> {` add:

```dart
  // Selectable statuses exclude OrderStatus.nothing. "All" maps to the
  // screen's default (OrderStatus.values), matching OrderScreenMyState.
  static const _statusOptions = [
    OrderStatus.moderate,
    OrderStatus.active,
    OrderStatus.hasExecutor,
    OrderStatus.completed,
    OrderStatus.archive,
  ];
  static const _statusAll = OrderStatus.values;
```

Then, after `late OrderCategoryPickerController _orderCategoryPickerController;` add:

```dart
  late StatusPickerController _statusPickerController;
```

- [ ] **Step 3: Seed the controller in `initState`**

After `_orderCategoryPickerController` is assigned in `initState`, add:

```dart
    _statusPickerController = StatusPickerController(
        StatusPickerController.seedFrom(state.params.statuses, _statusAll));
```

- [ ] **Step 4: Dispose the controller**

In `dispose`, before `super.dispose();`, add:

```dart
    _statusPickerController.dispose();
```

- [ ] **Step 5: Pass the resolved statuses in `_back`**

Replace the `changeParams` call in `_back` with:

```dart
    context.read<OrderScreenMyCubit>().changeParams(params.copyWithNull(
        startRow: 0,
        last: _indexPeriodPickerController.value,
        city: city,
        category: category,
        statuses: StatusPickerController.resolve(
            _statusPickerController.value, _statusAll)));
```

- [ ] **Step 6: Add the `StatusPicker` to the layout**

In `build`, insert this `Row` immediately after the `IndexPeriodPicker` `Row`:

```dart
            Row(
              children: [
                Expanded(
                  child: StatusPicker(
                    label: AppLocalizations.of(context)!.status,
                    controller: _statusPickerController,
                    options: _statusOptions,
                  ),
                )
              ],
            ),
```

- [ ] **Step 7: Verify it compiles and the suite is green**

Run: `flutter analyze lib/presentation/widgets/bottom_sheet/filters/filter_order_my_bottom_sheet.dart`
Expected: "No issues found!"

Run: `flutter test`
Expected: all tests pass.

- [ ] **Step 8: Commit**

```bash
git add lib/presentation/widgets/bottom_sheet/filters/filter_order_my_bottom_sheet.dart
git commit -m "feat: status filter in the my-orders sheet"
```

---

### Task 5: End-to-end manual verification

**Files:** none (verification only).

- [ ] **Step 1: Static analysis of the whole project**

Run: `flutter analyze`
Expected: "No issues found!"

- [ ] **Step 2: Full test suite**

Run: `flutter test`
Expected: all pass.

- [ ] **Step 3: Drive the app (use the `verify` or `run` skill)**

Launch the app and confirm on BOTH order-list screens:
- Open the filter → the new "Status" section shows "All" by default.
- Pick a concrete status (e.g. "In work") → Apply → the list reloads and shows only orders of that status. Confirm the network request carries `statuses[]` with the expected integer (public feed "In work" = 3; verify via the `print(data)` already in `OrderIndexRequestParams.toData` or a proxy/log).
- Re-open the filter → the previously chosen status is still selected (seeding round-trips).
- Pick "All" → Apply → the list returns to the screen's default set (public feed: active/in-work/completed; my orders: everything).

- [ ] **Step 4: Report results**

State plainly which of the above passed, pasting the observed `statuses` payload for at least one concrete selection. If anything fails, do not claim completion — debug with superpowers:systematic-debugging.

---

## Notes on test strategy (why no widget test on the sheets)

The sheets' `_back()` calls `context.router.pop(true)` (auto_route), which throws outside a real router stack, and the CupertinoPicker requires scroll-gesture simulation — both make a full-sheet widget test brittle for near-zero payoff. All branching logic is instead isolated in the pure, fully unit-tested `StatusPickerController.seedFrom` / `.resolve` (Task 2). The sheet changes (Tasks 3–4) are type-checked glue verified by `flutter analyze`, and the real behavior is confirmed by the Task 5 driven run.
