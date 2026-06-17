import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/service/main/service_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/last_day_picker.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterAdBottomSheet extends StatefulWidget {
  const FilterAdBottomSheet({super.key});

  @override
  State<FilterAdBottomSheet> createState() => _FilterAdBottomSheetState();
}

class _FilterAdBottomSheetState extends State<FilterAdBottomSheet> {
  late TextEditingController _fromController;
  late TextEditingController _beforeController;
  late IndexPeriodPickerController _indexPeriodPickerController;

  void _back() {
    var params = context.read<AdvertScreenMainCubit>().state.params;

    final from = int.tryParse(_fromController.value.text);
    final before = int.tryParse(_beforeController.value.text);
    final newParams = params.copyWith(
      startRow: 0,
      priceMin: from,
      priceMax: before,
      last: _indexPeriodPickerController.value,
    );
    context.read<AdvertScreenMainCubit>().changeParams(newParams);
    context.read<ServiceScreenMainCubit>().changeParams(newParams);

    context.router.pop(true);
  }

  @override
  void initState() {
    var state = context.read<AdvertScreenMainCubit>().state;
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
            Align(
              alignment: Alignment.centerLeft,
              child: SubTitleApp(
                AppLocalizations.of(context)!.price,
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: NumberFieldApp(
                    controller: _fromController,
                    label: AppLocalizations.of(context)!.from,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NumberFieldApp(
                    controller: _beforeController,
                    label: AppLocalizations.of(context)!.to,
                  ),
                ),
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
