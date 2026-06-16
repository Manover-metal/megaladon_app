import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

class AdvertCategoryPickerController
    extends ValueNotifier<AdvertCategoryModel?> {
  AdvertCategoryPickerController({AdvertCategoryModel? category})
      : super(category);

  void _changeAdvertCategory(AdvertCategoryModel category) {
    value = category;
    notifyListeners();
  }
}

class AdvertCategoryPicker extends StatefulWidget {
  const AdvertCategoryPicker(
      {required this.label,
      required this.controller,
      super.key,
      this.errorText});
  final String label;
  final AdvertCategoryPickerController controller;
  final String? errorText;

  @override
  State<AdvertCategoryPicker> createState() => _AdvertCategoryPickerState();
}

class _AdvertCategoryPickerState extends State<AdvertCategoryPicker> {
  Future<void> _handleClick() async {
    final advertCategories =
        context.read<DictionaryCubit>().state.advertCategories;

    if (advertCategories.isEmpty) return;

    var initialIndex = advertCategories.indexWhere(
      (c) => c.id == widget.controller.value?.id,
    );
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
                        ._changeAdvertCategory(advertCategories[selectedIndex]);
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
                children: advertCategories
                    .map((c) => Center(child: Text(c.name)))
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
          builder: (context, advertCategory, child) => GestureDetector(
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
                      color: widget.errorText != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(advertCategory?.name ?? '')),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
                if (widget.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      widget.errorText!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          valueListenable: widget.controller,
        ),
      );
}
