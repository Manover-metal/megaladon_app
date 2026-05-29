import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/dictionary/dictionary_cubit.dart';

class ServiceTypePickerController extends ValueNotifier<ServiceTypeModel> {
  ServiceTypePickerController({ServiceTypeModel? period})
      : super(period ?? ServiceTypeModel.nothing) {
    id = ++lastId;
  }
  static int lastId = 0;
  late int id;

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
  const ServiceTypePicker(
      {required this.label, required this.controller, super.key});
  final String label;
  final ServiceTypePickerController controller;

  @override
  State<ServiceTypePicker> createState() => _ServiceTypePickerState();
}

class _ServiceTypePickerState extends State<ServiceTypePicker> {
  Future<void> _handleClick() async {
    final serviceTypes = context.read<DictionaryCubit>().state.serviceTypes;

    if (serviceTypes.isEmpty) return;

    var initialIndex = serviceTypes.indexWhere(
      (s) => s.id == widget.controller.value.id,
    );
    if (initialIndex < 0) initialIndex = 0;

    var selectedIndex = initialIndex;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height / 3.5 + 44,
        color: Theme.of(ctx).colorScheme.surface,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                CupertinoButton(
                  child: Text(AppLocalizations.of(context)!.select),
                  onPressed: () {
                    widget.controller
                        ._changeServiceType(serviceTypes[selectedIndex]);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: initialIndex),
                itemExtent: 36,
                onSelectedItemChanged: (index) => selectedIndex = index,
                children: serviceTypes
                    .map((s) => Center(child: Text(s.name)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ValueListenableBuilder(
          builder: (context, serviceType, child) => GestureDetector(
            onTap: _handleClick,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(serviceType.name)),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
          valueListenable: widget.controller,
        ),
      );
}
