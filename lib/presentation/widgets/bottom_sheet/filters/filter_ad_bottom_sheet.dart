import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/category_model.dart';
import 'package:megaladon/data/models/request/index_period_enum.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/logic/screens/service/main/service_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/category_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/last_day_picker.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterAdBottomSheet extends StatefulWidget {
  const FilterAdBottomSheet({required this.kind, super.key});

  /// Дерево категорий открытой вкладки; категория применяется только к ней.
  final CategoryKind kind;

  @override
  State<FilterAdBottomSheet> createState() => _FilterAdBottomSheetState();
}

class _FilterAdBottomSheetState extends State<FilterAdBottomSheet> {
  late TextEditingController _queryController;
  late TextEditingController _fromController;
  late TextEditingController _beforeController;
  late IndexPeriodPickerController _indexPeriodPickerController;
  late CategoryPickerController _categoryController;
  late CityPickerController _cityController;
  late bool _withPhoto;
  late AdvertIndexSort _sort;

  void _back() {
    final adverts = context.read<AdvertScreenMainCubit>();
    final services = context.read<ServiceScreenMainCubit>();
    final isService = widget.kind == CategoryKind.service;
    AdvertIndexRequestParams withFilters(CategoryModel? category) =>
        adverts.state.params.withFilters(
          query: _queryController.text,
          category: category,
          city: _cityController.value,
          priceMin: int.tryParse(_fromController.text),
          priceMax: int.tryParse(_beforeController.text),
          last: _indexPeriodPickerController.value,
          withPhoto: _withPhoto,
          sort: _sort,
        );
    // Объявления и услуги фильтруются одной шторкой; тип каждой ленте
    // подставляет AdvertRepository.index. Категория — из дерева открытой
    // вкладки, у другой ленты остаётся своя.
    adverts.changeParams(withFilters(
        isService ? adverts.state.params.category : _categoryController.value));
    services.changeParams(withFilters(isService
        ? _categoryController.value
        : services.state.params.category));

    context.router.pop(true);
  }

  void _reset() {
    _queryController.clear();
    _fromController.clear();
    _beforeController.clear();
    _indexPeriodPickerController.value = IndexPeriod.allTime;
    _categoryController.value = null;
    _cityController.value = null;
    setState(() {
      _withPhoto = false;
      _sort = AdvertIndexSort.newest;
    });
  }

  @override
  void initState() {
    final params = context.read<AdvertScreenMainCubit>().state.params;
    _queryController = TextEditingController(text: params.query ?? '');
    _fromController =
        TextEditingController(text: params.priceMin?.toString() ?? '');
    _beforeController =
        TextEditingController(text: params.priceMax?.toString() ?? '');
    _indexPeriodPickerController = IndexPeriodPickerController(params.last);
    _categoryController = CategoryPickerController(
        category: widget.kind == CategoryKind.service
            ? context.read<ServiceScreenMainCubit>().state.params.category
            : params.category);
    _cityController = CityPickerController(city: params.city);
    _withPhoto = params.withPhoto;
    _sort = params.sort;
    super.initState();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _fromController.dispose();
    _beforeController.dispose();
    _indexPeriodPickerController.dispose();
    _categoryController.dispose();
    _cityController.dispose();
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
              controller: _queryController,
              label: l10n.search,
              hintText: l10n.filter_search_hint,
            ),
            CategoryPicker(
              kind: widget.kind,
              label: l10n.category,
              controller: _categoryController,
              withNull: true,
            ),
            CityPicker(
              label: l10n.city,
              controller: _cityController,
              withNull: true,
            ),
            SubTitleApp(l10n.price, textAlign: TextAlign.left),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: NumberFieldApp(
                      controller: _fromController, label: l10n.from),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NumberFieldApp(
                      controller: _beforeController, label: l10n.to),
                ),
              ],
            ),
            IndexPeriodPicker(
              label: l10n.last_period,
              controller: _indexPeriodPickerController,
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.filter_with_photo),
              value: _withPhoto,
              onChanged: (value) => setState(() => _withPhoto = value),
            ),
            SubTitleApp(l10n.sort, textAlign: TextAlign.left),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AdvertIndexSort.values
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
