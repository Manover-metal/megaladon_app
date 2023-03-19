
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<List<int>?> showOrderCategoryPicker(BuildContext context, List<OrderCategoryModel> cities) async {
  return await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<OrderCategoryModel>(
        data: cities.map((orderCategory) {
          return PickerItem<OrderCategoryModel>(
              text: Text(orderCategory.name),
              value: orderCategory
          );
        }).toList()
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Отмена',
    confirmText: 'Выбрать',
  ).showModal(context);
}


class OrderCategoryPickerController extends ValueNotifier<OrderCategoryModel> {


  OrderCategoryPickerController({OrderCategoryModel? category}) : super(category ?? OrderCategoryModel.nothing);



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
  late TextEditingController _textController;

  _handleClick(BuildContext context) => () async {
    List<OrderCategoryModel> orderCategories = context.read<DictionaryCubit>().state.orderCategories;

    List<int>? result = await showOrderCategoryPicker(context, orderCategories);

    try{
      if (result != null) {
        OrderCategoryModel orderCategory = orderCategories[result[0]];
        widget.controller._changeOrderCategory(orderCategory);
        _textController.value = TextEditingValue(text: orderCategory.name);
      }
    }catch (e) {}

    FocusManager.instance.primaryFocus?.unfocus();
  };

  @override
  void initState() {
    _textController = TextEditingController(text: widget.controller.value.name);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ValueListenableBuilder(
        builder: (BuildContext context, OrderCategoryModel orderCategory, Widget? child) {
          return TextField(
            controller: _textController,
            onTap: _handleClick(context),
            decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: const TextStyle(
                    fontSize: 18
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10)

            ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}