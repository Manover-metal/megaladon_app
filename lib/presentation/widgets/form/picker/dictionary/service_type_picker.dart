
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

Future<ServiceTypeModel?> showServiceTypePicker(BuildContext context) async {
  List<ServiceTypeModel> serviceTypes = context.read<DictionaryCubit>().state.serviceTypes;

  final result = await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<ServiceTypeModel>(
        data: [
          PickerItem<ServiceTypeModel>(
              text: Text(ServiceTypeModel.nothing.name),
              value: ServiceTypeModel.nothing
          ),
          ...serviceTypes.map((serviceType) {
            return PickerItem<ServiceTypeModel>(
                text: Text(serviceType.name),
                value: serviceType
            );
          }).toList()
        ]
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Cancel'.tr(),
    confirmText: 'select'.tr(),
  ).showModal(context);

  if(result == null) return null;
  if(result[0] == 0) return ServiceTypeModel.nothing;
  return serviceTypes[result[0] - 1];
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

  _handleClick() async {
    ServiceTypeModel? serviceType = await showServiceTypePicker(context);

    if (serviceType != null) {
      widget.controller._changeServiceType(serviceType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder(
        builder: (BuildContext context, ServiceTypeModel serviceType, Widget? child) {
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
                      Expanded(child: Text(serviceType.name)),
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