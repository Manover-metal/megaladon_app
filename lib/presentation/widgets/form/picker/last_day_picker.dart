import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

class IndexPeriodPickerController extends ValueNotifier<IndexPeriod> {
  IndexPeriodPickerController(IndexPeriod period) : super(period);

  void _changeIndexPeriod(IndexPeriod period) {
    value = period;
    notifyListeners();
  }
}

class IndexPeriodPicker extends StatefulWidget {
  const IndexPeriodPicker(
      {required this.label, required this.controller, super.key});
  final String label;
  final IndexPeriodPickerController controller;

  @override
  State<IndexPeriodPicker> createState() => _IndexPeriodPickerState();
}

class _IndexPeriodPickerState extends State<IndexPeriodPicker> {
  Future<void> _handleClick() async {
    const periods = IndexPeriod.values;
    var initialIndex = periods.indexWhere((p) => p == widget.controller.value);
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
                    widget.controller
                        ._changeIndexPeriod(periods[selectedIndex]);
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
                children: periods
                    .map((p) => Center(child: Text(p.toString())))
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
          builder: (context, period, child) => GestureDetector(
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
                    color: Theme.of(context).colorScheme.onSurface,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(period.toString())),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
          valueListenable: widget.controller,
        ),
      );
}
