import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/orders/main/order_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/last_day_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/status_picker.dart';
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
  static const _statusOptions = [
    OrderStatus.active,
    OrderStatus.hasExecutor,
    OrderStatus.completed,
  ];

  late IndexPeriodPickerController _indexPeriodPickerController;
  late CityPickerController _cityPickerController;
  late CategoryPickerController _orderCategoryPickerController;
  late StatusPickerController _statusPickerController;
  late TextEditingController _queryController;
  late TextEditingController _budgetFromController;
  late TextEditingController _budgetToController;
  late TextEditingController _daysController;
  late bool _withoutOffers;

  void _back() {
    var params = context.read<OrderScreenMainCubit>().state.params;
    final city = _cityPickerController.value;
    final category = _orderCategoryPickerController.value;
    context.read<OrderScreenMainCubit>().changeParams(params.copyWithNull(
        startRow: 0,
        last: _indexPeriodPickerController.value,
        city: city,
        category: category,
        statuses: StatusPickerController.resolve(
            _statusPickerController.value, _statusOptions),
        query: _queryController.text,
        priceMin: int.tryParse(_budgetFromController.text),
        priceMax: int.tryParse(_budgetToController.text),
        executionDaysMax: int.tryParse(_daysController.text),
        withoutOffers: _withoutOffers));
    context.router.pop(true);
  }

  @override
  void initState() {
    var state = context.read<OrderScreenMainCubit>().state;
    _indexPeriodPickerController =
        IndexPeriodPickerController(state.params.last);
    _cityPickerController = CityPickerController(city: state.params.city);
    _orderCategoryPickerController =
        CategoryPickerController(category: state.params.category);
    _statusPickerController = StatusPickerController(
        StatusPickerController.seedFrom(state.params.statuses, _statusOptions));
    final params = state.params;
    _queryController = TextEditingController(text: params.query ?? '');
    _budgetFromController =
        TextEditingController(text: params.priceMin?.toString() ?? '');
    _budgetToController =
        TextEditingController(text: params.priceMax?.toString() ?? '');
    _daysController =
        TextEditingController(text: params.executionDaysMax?.toString() ?? '');
    _withoutOffers = params.withoutOffers;
    super.initState();
  }

  @override
  void dispose() {
    _indexPeriodPickerController.dispose();
    _cityPickerController.dispose();
    _orderCategoryPickerController.dispose();
    _statusPickerController.dispose();
    _queryController.dispose();
    _budgetFromController.dispose();
    _budgetToController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.fromLTRB(
            20, 10, 20, 10 + MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleApp(AppLocalizations.of(context)!.filter),
            const Divider(
              thickness: 1,
              height: 20,
            ),
            TextFieldApp(
              controller: _queryController,
              label: AppLocalizations.of(context)!.search,
              hintText: AppLocalizations.of(context)!.filter_search_hint,
            ),
            Row(
              children: [
                Expanded(
                  child: CityPicker(
                    label: AppLocalizations.of(context)!.city,
                    controller: _cityPickerController,
                    withNull: true,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CategoryPicker(
                    kind: CategoryKind.service,
                    label: AppLocalizations.of(context)!.category,
                    controller: _orderCategoryPickerController,
                    withNull: true,
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SubTitleApp(AppLocalizations.of(context)!.filter_budget),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: NumberFieldApp(
                      controller: _budgetFromController,
                      label: AppLocalizations.of(context)!.from),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NumberFieldApp(
                      controller: _budgetToController,
                      label: AppLocalizations.of(context)!.to),
                ),
              ],
            ),
            NumberFieldApp(
              controller: _daysController,
              label: AppLocalizations.of(context)!.filter_max_days,
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocalizations.of(context)!.filter_without_offers),
              value: _withoutOffers,
              onChanged: (value) => setState(() => _withoutOffers = value),
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
            Row(
              children: [
                Expanded(
                  child: StatusPicker(
                    label: AppLocalizations.of(context)!.status,
                    controller: _statusPickerController,
                    options: _statusOptions,
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
        )),
      );
}
