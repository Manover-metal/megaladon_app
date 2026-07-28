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
