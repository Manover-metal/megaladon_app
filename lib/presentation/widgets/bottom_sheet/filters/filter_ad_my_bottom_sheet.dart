import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/index/advert_index_request_params.dart';
import 'package:megaladon/logic/screens/advert/my/advert_screen_my_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/last_day_picker.dart';
import 'package:megaladon/presentation/widgets/form/field/number_field.dart';
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


  _back() {
    AdvertIndexRequestParams params = context.read<AdvertScreenMyCubit>().state.params;
    final from = int.tryParse(_fromController.value.text);
    final before = int.tryParse(_beforeController.value.text);
    context.read<AdvertScreenMyCubit>().changeParams(params.copyWith(
      startRow: 0,
      priceMin : from,
      priceMax: before,
      last: _indexPeriodPickerController.value,
    ));
    context.router.pop(true);
  }

  @override
  void initState() {
    AdvertScreenMyState state = context.read<AdvertScreenMyCubit>().state;
    _fromController = TextEditingController(text: state.params.priceMin != null ? state.params.priceMin.toString() : '');
    _beforeController = TextEditingController(text: state.params.priceMax != null ? state.params.priceMax.toString() : '');
    _indexPeriodPickerController = IndexPeriodPickerController(state.params.last);
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
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           TitleApp('filter'.tr()),
          const Divider(thickness: 1,height: 20,),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text('price_from'.tr(), style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700
                  )),
                ),
                Expanded(
                    child: NumberFieldApp(controller: _fromController,)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('price_to'.tr(), style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700
                  )),
                ),
                Expanded(child: NumberFieldApp(controller: _beforeController)),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: IndexPeriodPicker(label: 'last_period'.tr(), controller: _indexPeriodPickerController,),
              )
            ],
          ),
          const SizedBox(height: 30,),
          ElevatedButtonApp(
              text: 'Apply'.tr(),
              onPressed: _back
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}