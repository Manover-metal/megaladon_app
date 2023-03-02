import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/request/params/store_index_request_params.dart';
import 'package:megaladon/logic/screens/store/main/store_screen_main_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/city_picker.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/store_type_picker.dart';
import 'package:megaladon/presentation/widgets/text/title.dart';

class FilterStoreBottomSheet extends StatefulWidget {
  @override
  State<FilterStoreBottomSheet> createState() => _FilterStoreBottomSheetState();
}

class _FilterStoreBottomSheetState extends State<FilterStoreBottomSheet> {
  late CityPickerController _cityPickerController;
  late StoreTypePickerController _storeTypePickerController;

  _back() {
    StoreIndexRequestParams params = context.read<StoreScreenMainCubit>().state.params;
    params.startRow = 0;
    if(_cityPickerController.value.id != -1) {
      params.city = _cityPickerController.value;
    }
    if(_storeTypePickerController.value.id != -1) {
      params.type = _storeTypePickerController.value;
    }
    context.read<StoreScreenMainCubit>().changeParams(params);
    context.router.pop(true);
  }

  @override
  void initState() {
    StoreScreenMainState state = context.read<StoreScreenMainCubit>().state;
    _cityPickerController = CityPickerController(city: state.params.city);
    _storeTypePickerController = StoreTypePickerController(type: state.params.type);
    super.initState();
  }

  @override
  void dispose() {
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
            Divider(thickness: 1,height: 20,),
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
                  child: StoreTypePicker(label: 'Тип', controller: _storeTypePickerController,),
                )
              ],
            ),
            SizedBox(height: 30,),
            ElevatedButtonApp(
                text: 'Применить',
                onPressed: _back
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}