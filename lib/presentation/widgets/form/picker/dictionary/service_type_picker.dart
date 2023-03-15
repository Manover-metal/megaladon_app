
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<List<int>?> showServiceTypePicker(BuildContext context, List<ServiceTypeModel> cities) async {
  return await Picker(
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<ServiceTypeModel>(
        data: cities.map((serviceType) {
          return PickerItem<ServiceTypeModel>(
              text: Text(serviceType.name),
              value: serviceType
          );
        }).toList()
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Отмена',
    confirmText: 'Выбрать',
  ).showModal(context);
}


class ServiceTypePickerController extends ValueNotifier<ServiceTypeModel> {
  static int lastId = 0;
  late int id;

  ServiceTypePickerController({ServiceTypeModel? period}) : super(period ?? ServiceTypeModel.nothing) {
    id = ++lastId;
  }




  void _changeServiceType(ServiceTypeModel period) {
    value = period;
    notifyListeners();
  }

  @override
  void dispose() {
    value = ServiceTypeModel.nothing;
    super.dispose();
  }
}

class ServiceTypePicker extends StatefulWidget {
  final String label;
  final ServiceTypePickerController controller;

  const ServiceTypePicker({super.key, required this.label, required this.controller});

  @override
  State<ServiceTypePicker> createState() => _ServiceTypePickerState();
}

class _ServiceTypePickerState extends State<ServiceTypePicker> {
  late TextEditingController _textController;

  _handleClick(BuildContext context) => () async {
    List<ServiceTypeModel> serviceTypes = context.read<DictionaryCubit>().state.serviceTypes;

    List<int>? result = await showServiceTypePicker(context, serviceTypes);
    try {
      if (result != null) {
        ServiceTypeModel serviceType = serviceTypes[result[0]];
        widget.controller._changeServiceType(serviceType);
        _textController.value = TextEditingValue(text: serviceType.name);
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
  void didUpdateWidget(covariant ServiceTypePicker oldWidget) {
    if(oldWidget.controller.value.id != widget.controller.value.id) {
      _textController.dispose();
      _textController = TextEditingController(text: widget.controller.value.name);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ValueListenableBuilder(
        builder: (BuildContext context, ServiceTypeModel serviceType, Widget? child) {
          return TextField(
            controller: _textController,
            onTap: _handleClick(context),
            decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: const TextStyle(
                    fontSize: 18
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10)

            ),
          );
        },
        valueListenable: widget.controller,
      ),
    );
  }
}