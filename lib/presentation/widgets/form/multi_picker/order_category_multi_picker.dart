import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';

class OrderCategoryMultiPickerController
    extends ValueNotifier<List<OrderCategoryPickerController>> {
  OrderCategoryMultiPickerController({List<OrderCategoryModel>? categories})
      : super(categories != null
            ? categories
                .map((e) => OrderCategoryPickerController(category: e))
                .toList()
            : []);

  void _listener() {
    notifyListeners();
  }

  void _addCategory(OrderCategoryPickerController controller) {
    value = [...value, controller];
    controller.addListener(_listener);
    _listener();
  }

  void _removeByIndex(int index) {
    value = List.from(value)..removeAt(index);
    _listener();
  }

  @override
  void dispose() {
    for (final controller in value) {
      controller
        ..removeListener(_listener)
        ..dispose();
    }
    super.dispose();
  }
}

class OrderCategoryMultiPicker extends StatefulWidget {
  const OrderCategoryMultiPicker({required this.controllers, super.key});
  final OrderCategoryMultiPickerController controllers;

  @override
  State<OrderCategoryMultiPicker> createState() =>
      _OrderCategoryMultiPickerState();
}

class _OrderCategoryMultiPickerState extends State<OrderCategoryMultiPicker> {
  void _add() {
    widget.controllers._addCategory(OrderCategoryPickerController());
  }

  Null Function() _removeByIndex(int index) => () {
        widget.controllers._removeByIndex(index);
      };

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ValueListenableBuilder(
            valueListenable: widget.controllers,
            builder: (context, categories, child) => ListView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OrderCategoryPicker(
                            label: AppLocalizations.of(context)!.order_category,
                            controller: widget.controllers.value[item],
                          ),
                        ),
                        IconButton(
                          onPressed: _removeByIndex(item),
                          icon: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      ],
                    )),
          ),
          OutlinedButtonApp(
            text: AppLocalizations.of(context)!.add_order_category,
            onPressed: _add,
          )
        ],
      );
}
