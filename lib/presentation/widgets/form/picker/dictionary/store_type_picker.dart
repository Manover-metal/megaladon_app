
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

// Future<StoreTypeModel?> showStoreTypePicker(BuildContext context) async {
//   List<StoreTypeModel> storeTypes = context.read<DictionaryCubit>().state.storeTypes;


//   final result = await Picker(
//     itemExtent: 30,
//     height: MediaQuery.of(context).size.height / 3.5,
//     backgroundColor: Theme.of(context).colorScheme.background,
//     adapter: PickerDataAdapter<StoreTypeModel>(
//         data: storeTypes.map((storeType) {
//           return PickerItem<StoreTypeModel>(
//               text: Text(storeType.name),
//               value: storeType
//           );
//         }).toList()
//     ),
//     changeToFirst: false,
//     hideHeader: false,
//     cancelText: 'Cancel'.tr(),
//     confirmText: 'select'.tr(),
//   ).showModal(context);


//   if(result == null) return null;
//   return storeTypes[result[0]];
// }


class StoreTypePickerController extends ValueNotifier<StoreTypeModel> {
  StoreTypePickerController({StoreTypeModel?  type}) : super(type ?? StoreTypeModel.nothing);

  void _changeStoreType(StoreTypeModel type) {
    value = type;
    notifyListeners();
  }
}

class StoreTypePicker extends StatefulWidget {
  final String label;
  final StoreTypePickerController controller;

  const StoreTypePicker({super.key, required this.label, required this.controller});

  @override
  State<StoreTypePicker> createState() => _StoreTypePickerState();
}

class _StoreTypePickerState extends State<StoreTypePicker> {

  _handleClick() async {
    StoreTypeModel? storeType = null;

    if (storeType != null) {
      widget.controller._changeStoreType(storeType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder(
        builder: (BuildContext context, StoreTypeModel storeType, Widget? child) {
          return GestureDetector(
            onTap: _handleClick,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,

                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 0.5
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(storeType.name)),
                      const Icon(Icons.keyboard_arrow_down_outlined)
                    ],
                  ),
                )
              ],
            ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}