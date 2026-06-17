import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/logic/screens/service/my/service_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/last_day_picker.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterMyAdBottomSheet extends StatefulWidget {
  const FilterMyAdBottomSheet({super.key});

  @override
  State<FilterMyAdBottomSheet> createState() => _FilterMyAdBottomSheetState();
}

class _FilterMyAdBottomSheetState extends State<FilterMyAdBottomSheet> {
  late TextEditingController _fromController;
  late TextEditingController _beforeController;
  late IndexPeriodPickerController _indexPeriodPickerController;

  void _back() {
    var params = context.read<AdvertScreenMyCubit>().state.params;
    final from = int.tryParse(_fromController.value.text);
    final before = int.tryParse(_beforeController.value.text);
    final newParams = params.copyWith(
      startRow: 0,
      priceMin: from,
      priceMax: before,
      last: _indexPeriodPickerController.value,
    );
    context.read<AdvertScreenMyCubit>().changeParams(newParams);
    context.read<ServiceScreenMyCubit>().changeParams(newParams);
    context.router.pop(true);
  }

  @override
  void initState() {
    var state = context.read<AdvertScreenMyCubit>().state;
    _fromController = TextEditingController(
        text: state.params.priceMin != null
            ? state.params.priceMin.toString()
            : '');
    _beforeController = TextEditingController(
        text: state.params.priceMax != null
            ? state.params.priceMax.toString()
            : '');
    _indexPeriodPickerController =
        IndexPeriodPickerController(state.params.last);
    super.initState();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _beforeController.dispose();
    _indexPeriodPickerController.dispose();
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
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(AppLocalizations.of(context)!.price_from,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                      child: NumberFieldApp(
                    controller: _fromController,
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(AppLocalizations.of(context)!.price_to,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                      child: NumberFieldApp(controller: _beforeController)),
                ],
              ),
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
