import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/form/field/phone_field.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';

class ContactTypePickerController extends ValueNotifier<ContactType> {
  ContactTypePickerController({ContactModel? type})
      : super(type?.type ?? ContactType.phone) {
    _valueController = TextEditingController(text: type?.value);
    if (_checkPhone()) {
      _nameController = TextEditingController(text: type?.contactName);
    }
  }
  late TextEditingController _valueController;
  TextEditingController? _nameController;

  void _changeContactType(ContactType type) {
    value = type;

    _valueController.dispose();
    _nameController?.dispose();

    _valueController = TextEditingController();
    if (_checkPhone()) {
      _nameController = TextEditingController();
    } else {
      _nameController = null;
    }
    notifyListeners();
  }

  ContactModel getData() => ContactModel(
        type: value,
        value: _valueController.value.text,
        contactName: _nameController?.value.text,
      );

  bool _checkPhone() =>
      value == ContactType.phone || value == ContactType.home_phone;

  @override
  void dispose() {
    _valueController.dispose();
    _nameController?.dispose();
    super.dispose();
  }
}

class ContactTypePicker extends StatefulWidget {
  const ContactTypePicker(
      {required this.label, required this.controller, super.key});
  final String label;
  final ContactTypePickerController controller;

  @override
  State<ContactTypePicker> createState() => _ContactTypePickerState();
}

class _ContactTypePickerState extends State<ContactTypePicker> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController =
        TextEditingController(text: widget.controller.value.toString());
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ContactTypePicker oldWidget) {
    if (oldWidget.controller.value != widget.controller.value) {
      _textController.dispose();
      _textController =
          TextEditingController(text: widget.controller.value.toString());
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> Function() _handleClickType(BuildContext context) => () async {
        const types = ContactType.values;
        var initialIndex =
            types.indexWhere((t) => t == widget.controller.value);
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
                        final contactType = types[selectedIndex];
                        widget.controller._changeContactType(contactType);
                        _textController.value =
                            TextEditingValue(text: contactType.toString());
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
                    children: types
                        .map((t) => Center(
                            child: Text(
                                t.localize(AppLocalizations.of(context)!))))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );

        FocusManager.instance.primaryFocus?.unfocus();
      };

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        builder: (context, contactType, child) => Column(
          children: [
            GestureDetector(
              onTap: _handleClickType(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
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
                        Expanded(
                            child: Text(contactType
                                .localize(AppLocalizations.of(context)!))),
                        const Icon(Icons.keyboard_arrow_down_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Builder(builder: (context) {
              switch (widget.controller.value) {
                case ContactType.phone:
                  return PhoneField(
                    controller: widget.controller._valueController,
                    label: widget.controller.value
                        .localize(AppLocalizations.of(context)!),
                  );
                case ContactType.home_phone:
                  return PhoneField(
                    controller: widget.controller._valueController,
                    label: widget.controller.value
                        .localize(AppLocalizations.of(context)!),
                  );
                case ContactType.site:
                  return TextFieldApp(
                    controller: widget.controller._valueController,
                    label: widget.controller.value
                        .localize(AppLocalizations.of(context)!),
                  );
                case ContactType.email:
                  return TextFieldApp(
                    controller: widget.controller._valueController,
                    label: widget.controller.value
                        .localize(AppLocalizations.of(context)!),
                  );
              }
            }),
            if (widget.controller._nameController != null)
              TextFieldApp(
                controller: widget.controller._nameController,
                label: AppLocalizations.of(context)!.contact_name,
              ),
          ],
        ),
        valueListenable: widget.controller,
      );
}
