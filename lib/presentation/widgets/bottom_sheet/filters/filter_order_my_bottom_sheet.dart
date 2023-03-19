import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/order_category_model.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/last_day_picker.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterMyOrderBottomSheet extends StatefulWidget {
  const FilterMyOrderBottomSheet({super.key});

  @override
  State<FilterMyOrderBottomSheet> createState() => _FilterMyOrderBottomSheetState();
}

class _FilterMyOrderBottomSheetState extends State<FilterMyOrderBottomSheet> {
  late IndexPeriodPickerController _indexPeriodPickerController;
  late CityPickerController _cityPickerController;
  late OrderCategoryPickerController _orderCategoryPickerController;


  _back() {
    OrderIndexRequestParams params = context.read<OrderScreenMyCubit>().state.params;
    final city = _cityPickerController.value;
    final category = _orderCategoryPickerController.value;
    context.read<OrderScreenMyCubit>().changeParams(params.copyWith(
        startRow: 0,
        last: _indexPeriodPickerController.value,
        city: city.id == CityModel.nothing.id ? null : city,
        category: category.id == OrderCategoryModel.nothing.id ? null : category
    ));
    context.router.pop(true);
  }

  @override
  void initState() {
    OrderScreenMyState state = context.read<OrderScreenMyCubit>().state;
    _indexPeriodPickerController = IndexPeriodPickerController(state.params.last);
    _cityPickerController = CityPickerController(city: state.params.city);
    _orderCategoryPickerController = OrderCategoryPickerController(category: state.params.category);

    super.initState();
  }

  @override
  void dispose() {
    _indexPeriodPickerController.dispose();
    _cityPickerController.dispose();
    _orderCategoryPickerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleApp('Фильтр'),
          const Divider(thickness: 1,height: 20,),
          Row(
            children: [
              Expanded(
                child: CityPicker(label: 'Город', controller: _cityPickerController,),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: OrderCategoryPicker(label: 'Категория', controller: _orderCategoryPickerController,),
              )
            ],
          ),
          const SizedBox(height: 30,),
          ElevatedButtonApp(
              text: 'Применить',
              onPressed: _back
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}