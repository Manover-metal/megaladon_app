import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/index/store_index_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterStoreBottomSheet extends StatefulWidget {
  const FilterStoreBottomSheet({super.key});

  @override
  State<FilterStoreBottomSheet> createState() => _FilterStoreBottomSheetState();
}

class _FilterStoreBottomSheetState extends State<FilterStoreBottomSheet> {
  static const _ratingOptions = [null, 3, 4, 5];

  late CityPickerController _cityPickerController;
  late TextEditingController _nameController;
  late int? _ratingMin;
  late StoreIndexSort _sort;

  void _back() {
    final params = context.read<StoreScreenMainCubit>().state.params;
    context.read<StoreScreenMainCubit>().changeParams(params.withFilters(
          city: _cityPickerController.value,
          name: _nameController.text,
          ratingMin: _ratingMin,
          sort: _sort,
        ));
    context.router.pop(true);
  }

  void _reset() {
    _nameController.clear();
    _cityPickerController.value = null;
    setState(() {
      _ratingMin = null;
      _sort = StoreIndexSort.newest;
    });
  }

  @override
  void initState() {
    final params = context.read<StoreScreenMainCubit>().state.params;
    _cityPickerController = CityPickerController(city: params.city);
    _nameController = TextEditingController(text: params.name ?? '');
    _ratingMin = params.ratingMin;
    _sort = params.sort;
    super.initState();
  }

  @override
  void dispose() {
    _cityPickerController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.fromLTRB(
          20, 10, 20, 10 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: TitleApp(l10n.filter)),
                TextButton(onPressed: _reset, child: Text(l10n.filter_reset)),
              ],
            ),
            const Divider(thickness: 1, height: 20),
            TextFieldApp(
              controller: _nameController,
              label: l10n.filter_store_name,
            ),
            CityPicker(
              label: l10n.city,
              controller: _cityPickerController,
              withNull: true,
            ),
            const SizedBox(height: 5),
            SubTitleApp(l10n.filter_rating_min, textAlign: TextAlign.left),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              children: _ratingOptions
                  .map((rating) => ChoiceChip(
                        label: Text(rating == null ? l10n.all : '$rating ★'),
                        selected: _ratingMin == rating,
                        onSelected: (_) => setState(() => _ratingMin = rating),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            SubTitleApp(l10n.sort, textAlign: TextAlign.left),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              children: StoreIndexSort.values
                  .map((sort) => ChoiceChip(
                        label: Text(sort.localize(l10n)),
                        selected: _sort == sort,
                        onSelected: (_) => setState(() => _sort = sort),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButtonApp(text: l10n.apply, onPressed: _back),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
