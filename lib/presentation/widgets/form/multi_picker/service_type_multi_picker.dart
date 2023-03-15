import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/service_type_picker.dart';

class ServiceTypeMultiPickerController extends ValueNotifier<List<ServiceTypePickerController>> {


  ServiceTypeMultiPickerController({List<ServiceTypePickerController>? services }) : super(services ?? []);

  _listener() {
    notifyListeners();
  }

  void _addServiceType(ServiceTypePickerController controller) {
    value = [...value, controller];
    controller.addListener(_listener);
    _listener();
  }

  void _removeByIndex(int index) {
    value = List.from(value)..removeAt(index);
    _listener();
  }

  @override
  void dispose() {
    for (var value in value) {
      value.removeListener(_listener);
      value.dispose();
    }
    super.dispose();
  }
}

class ServiceTypeMultiPicker extends StatefulWidget {
  final ServiceTypeMultiPickerController serviceTypeControllers;

  const ServiceTypeMultiPicker({super.key, required this.serviceTypeControllers});

  @override
  State<ServiceTypeMultiPicker> createState() => _ServiceTypeMultiPickerState();
}

class _ServiceTypeMultiPickerState extends State<ServiceTypeMultiPicker> {
  _addService() {
    widget.serviceTypeControllers._addServiceType(ServiceTypePickerController());
  }

  _removeByIndex(int index) => () {
    widget.serviceTypeControllers._removeByIndex(index);
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.serviceTypeControllers,
          builder: (context, List<ServiceTypePickerController> serviceTypes, Widget? child) {
            return ListView.builder(
                itemCount: serviceTypes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) {
                  return Row(
                    children: [
                      Expanded(
                        child: ServiceTypePicker(
                          label: 'Сервис',
                          controller: widget.serviceTypeControllers.value[item],
                        ),
                      ),
                      IconButton(
                        onPressed: _removeByIndex(item),
                        icon: Icon(Icons.remove_circle_outline_rounded,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    ],
                  );
                }
            );
          },
        ),
        ElevatedButtonApp(text: 'Добавить сервис', onPressed: _addService,)
      ],
    );
  }
}