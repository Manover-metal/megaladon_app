
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<OrderCategoryModel?> showOrderCategoryPicker(BuildContext context) async {
  List<OrderCategoryModel> orderCategories = context.read<DictionaryCubit>().state.orderCategories;


  final result = await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<OrderCategoryModel>(
        data: orderCategories.map((orderCategory) {
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

  if(result == null) return null;
  return orderCategories[result[0]];
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

  _handleClick() async {
    OrderCategoryModel? orderCategory = await showOrderCategoryPicker(context);

    if (orderCategory != null) {
      widget.controller._changeOrderCategory(orderCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, OrderCategoryModel orderCategory, Widget? child) {
        return GestureDetector(
          onTap: _handleClick,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 0.5
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(orderCategory.name)),
                    const Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              )
            ],
          ),
        );
      },
      valueListenable: widget.controller,
    );
  }
}