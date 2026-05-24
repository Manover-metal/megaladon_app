import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

class OrderCategoryPickerController extends ValueNotifier<OrderCategoryModel> {
  OrderCategoryPickerController({OrderCategoryModel? category})
      : super(category ?? OrderCategoryModel.nothing);

  void _changeOrderCategory(OrderCategoryModel category) {
    value = category;
    notifyListeners();
  }
}

class OrderCategoryPicker extends StatefulWidget {
  final String label;
  final OrderCategoryPickerController controller;

  const OrderCategoryPicker({super.key, required this.label, required this.controller});

  @override
  State<OrderCategoryPicker> createState() => _OrderCategoryPickerState();
}

class _OrderCategoryPickerState extends State<OrderCategoryPicker> {
  _handleClick() async {
    final List<OrderCategoryModel> orderCategories =
        context.read<DictionaryCubit>().state.orderCategories;

    if (orderCategories.isEmpty) return;

    int initialIndex = orderCategories.indexWhere(
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
                        ._changeOrderCategory(orderCategories[selectedIndex]);
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
                children: orderCategories
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
        builder: (BuildContext context, OrderCategoryModel orderCategory, Widget? child) {
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
                      Expanded(child: Text(orderCategory.name)),
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
