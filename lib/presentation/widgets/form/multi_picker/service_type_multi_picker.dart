import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/service_type_picker.dart';

class ServiceTypeMultiPickerController
    extends ValueNotifier<List<ServiceTypePickerController>> {
  ServiceTypeMultiPickerController({List<ServiceTypeModel>? services})
      : super(services != null
            ? services
                .map((e) => ServiceTypePickerController(period: e))
                .toList()
            : []);

  void _listener() {
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
    for (final value in value) {
      value.removeListener(_listener);
      value.dispose();
    }
    super.dispose();
  }
}

class ServiceTypeMultiPicker extends StatefulWidget {
  const ServiceTypeMultiPicker(
      {required this.serviceTypeControllers, super.key});
  final ServiceTypeMultiPickerController serviceTypeControllers;

  @override
  State<ServiceTypeMultiPicker> createState() => _ServiceTypeMultiPickerState();
}

class _ServiceTypeMultiPickerState extends State<ServiceTypeMultiPicker> {
  void _addService() {
    widget.serviceTypeControllers
        ._addServiceType(ServiceTypePickerController());
  }

  Null Function() _removeByIndex(int index) => () {
        widget.serviceTypeControllers._removeByIndex(index);
      };

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ValueListenableBuilder(
            valueListenable: widget.serviceTypeControllers,
            builder: (context, serviceTypes, child) => ListView.builder(
                itemCount: serviceTypes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) => Row(
                      children: [
                        Expanded(
                          child: ServiceTypePicker(
                            label:
                                AppLocalizations.of(context)!.service_category,
                            controller:
                                widget.serviceTypeControllers.value[item],
                          ),
                        ),
                        IconButton(
                          onPressed: _removeByIndex(item),
                          icon: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      ],
                    )),
          ),
          OutlinedButtonApp(
            text: AppLocalizations.of(context)!.add_service,
            onPressed: _addService,
          )
        ],
      );
}
