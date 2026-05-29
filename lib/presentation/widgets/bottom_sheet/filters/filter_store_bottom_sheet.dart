import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterStoreBottomSheet extends StatefulWidget {
  const FilterStoreBottomSheet({super.key});

  @override
  State<FilterStoreBottomSheet> createState() => _FilterStoreBottomSheetState();
}

class _FilterStoreBottomSheetState extends State<FilterStoreBottomSheet> {
  late CityPickerController _cityPickerController;

  void _back() {
    var params = context.read<StoreScreenMainCubit>().state.params;
    final city = _cityPickerController.value;
    context.read<StoreScreenMainCubit>().changeParams(params.copyWith(
          startRow: 0,
          city: city,
        ));
    context.router.pop(true);
  }

  @override
  void initState() {
    var state = context.read<StoreScreenMainCubit>().state;
    _cityPickerController = CityPickerController(city: state.params.city);
    super.initState();
  }

  @override
  void dispose() {
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
