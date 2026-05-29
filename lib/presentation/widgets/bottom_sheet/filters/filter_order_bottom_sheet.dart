import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/order_category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/last_day_picker.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterOrderBottomSheet extends StatefulWidget {
  const FilterOrderBottomSheet({super.key});

  Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      elevation: 100,
      builder: (_) => this);

  @override
  State<FilterOrderBottomSheet> createState() => _FilterOrderBottomSheetState();
}

class _FilterOrderBottomSheetState extends State<FilterOrderBottomSheet> {
  late IndexPeriodPickerController _indexPeriodPickerController;
  late CityPickerController _cityPickerController;
  late OrderCategoryPickerController _orderCategoryPickerController;

  void _back() {
    var params = context.read<OrderScreenMainCubit>().state.params;
    final city = _cityPickerController.value;
    final category = _orderCategoryPickerController.value;
    context.read<OrderScreenMainCubit>().changeParams(params.copyWith(
        startRow: 0,
        last: _indexPeriodPickerController.value,
        city: city,
        category: category));
    context.router.pop(true);
  }

  @override
  void initState() {
    var state = context.read<OrderScreenMainCubit>().state;
    _indexPeriodPickerController =
        IndexPeriodPickerController(state.params.last);
    _cityPickerController = CityPickerController(city: state.params.city);
    _orderCategoryPickerController =
        OrderCategoryPickerController(category: state.params.category);
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
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleApp(AppLocalizations.of(context)!.filter),
            const Divider(
              thickness: 1,
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: CityPicker(
                    label: AppLocalizations.of(context)!.city,
                    controller: _cityPickerController,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OrderCategoryPicker(
                    label: AppLocalizations.of(context)!.category,
                    controller: _orderCategoryPickerController,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: IndexPeriodPicker(
                    label: AppLocalizations.of(context)!.last_period,
                    controller: _indexPeriodPickerController,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButtonApp(
                text: AppLocalizations.of(context)!.apply, onPressed: _back),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      );
}
