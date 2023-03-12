// ignore_for_file: use_key_in_widget_constructors

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/advert_index_request_params.dart';
import 'package:megaladon/data/repositories/advert_repository.dart';
import 'package:megaladon/logic/screens/advert/details/advert_screen_details_cubit.dart';
import 'package:megaladon/logic/screens/advert/main/advert_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/last_day_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/text_number_field.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterAdBottomSheet extends StatefulWidget {
  @override
  State<FilterAdBottomSheet> createState() => _FilterAdBottomSheetState();
}

class _FilterAdBottomSheetState extends State<FilterAdBottomSheet> {
  late TextEditingController _fromController;
  late TextEditingController _beforeController;
  late IndexPeriodPickerController _indexPeriodPickerController;

  _back() {
    AdvertIndexRequestParams params =
        context.read<AdvertScreenMainCubit>().state.params;

  final from = int.tryParse(_fromController.value.text);
  final before = int.tryParse(_beforeController.value.text);
    context.read<AdvertScreenMainCubit>().changeParams(params.copyWith(
          startRow: 0,
          priceMin : from,
          priceMax: before,
          last: _indexPeriodPickerController.value,
        ));

    // int? from = int.tryParse(_fromController.value.text);
    // int? before = int.tryParse(_beforeController.value.text);
    // params.priceMin = from;
    // params.priceMax = before;
    // params.last = _indexPeriodPickerController.value;
    // params.startRow = 0;
    // context.read<AdvertScreenMainCubit>().changeParams(params);

    // final city = _cityPickerController.value;
    // final category = _orderCategoryPickerController.value;
    // context.read<OrderScreenMainCubit>().changeParams(params.copyWith(
    //   startRow: 0,
    //   last: _indexPeriodPickerController.value,
    //   city: city.id == CityModel.nothing.id ? null : city,
    //   category: category.id == OrderCategoryModel.nothing.id ? null : category
    // ));
    context.router.pop(true);
  }

  @override
  void initState() {
    AdvertScreenMainState state = context.read<AdvertScreenMainCubit>().state;
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TitleApp('Фильтр'),
            Divider(
              thickness: 1,
              height: 20,
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text('Цена от:',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                      child: TextNumberFieldApp(
                    controller: _fromController,
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('До:',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                      child: TextNumberFieldApp(controller: _beforeController)),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: IndexPeriodPicker(
                    label: 'За последние период',
                    controller: _indexPeriodPickerController,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButtonApp(text: 'Применить', onPressed: _back),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
