import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

class AdvertCategoryPickerController extends ValueNotifier<AdvertCategoryModel> {
  AdvertCategoryPickerController({AdvertCategoryModel? category})
      : super(category ?? AdvertCategoryModel.nothing);

  void _changeAdvertCategory(AdvertCategoryModel category) {
    value = category;
    notifyListeners();
  }
}

class AdvertCategoryPicker extends StatefulWidget {
  final String label;
  final AdvertCategoryPickerController controller;

  const AdvertCategoryPicker({super.key, required this.label, required this.controller});

  @override
  State<AdvertCategoryPicker> createState() => _AdvertCategoryPickerState();
}

class _AdvertCategoryPickerState extends State<AdvertCategoryPicker> {
  _handleClick() async {
    final List<AdvertCategoryModel> advertCategories =
        context.read<DictionaryCubit>().state.advertCategories;

    if (advertCategories.isEmpty) return;

    int initialIndex = advertCategories.indexWhere(
      (c) => c.id == widget.controller.value.id,
    );
    if (initialIndex < 0) initialIndex = 0;

    int selectedIndex = initialIndex;

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
                  child: Text('Cancel'.tr()),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                CupertinoButton(
                  child: Text('select'.tr()),
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder(
        builder: (BuildContext context, AdvertCategoryModel advertCategory, Widget? child) {
          return GestureDetector(
            onTap: _handleClick,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
                      Expanded(child: Text(advertCategory.name)),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}
