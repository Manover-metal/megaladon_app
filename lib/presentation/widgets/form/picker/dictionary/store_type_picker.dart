
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<List<int>?> showStoreTypePicker(BuildContext context, List<StoreTypeModel> cities) async {
  return await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<StoreTypeModel>(
        data: cities.map((storeType) {
          return PickerItem<StoreTypeModel>(
              text: Text(storeType.name),
              value: storeType
          );
        }).toList()
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Отмена',
    confirmText: 'Выбрать',
  ).showModal(context);
}


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
  late TextEditingController _textController;

  _handleClick(BuildContext context) => () async {
    List<StoreTypeModel> storeTypes = context.read<DictionaryCubit>().state.storeTypes;

    List<int>? result = await showStoreTypePicker(context, storeTypes);
    try {
      if (result != null) {
        StoreTypeModel storeType = storeTypes[result[0]];
        widget.controller._changeStoreType(storeType);
        _textController.value = TextEditingValue(text: storeType.name);
      }
    }catch (e) {}

    FocusManager.instance.primaryFocus?.unfocus();
  };

  @override
  void initState() {
    _textController = TextEditingController(text: widget.controller.value.name);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ValueListenableBuilder(
        builder: (BuildContext context, StoreTypeModel storeType, Widget? child) {
          return TextField(
            controller: _textController,
            onTap: _handleClick(context),
            decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: const TextStyle(
                    fontSize: 18
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10)

          ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}