import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/contact_model.dart';

class ContactTypePickerController extends ValueNotifier<ContactType> {
  late TextEditingController _valueController;
  TextEditingController? _nameController;

  ContactTypePickerController({ContactModel? type})
      : super(type?.type ?? ContactType.phone) {
    _valueController = TextEditingController(text: type?.value);
    if (_checkPhone()) {
      _nameController = TextEditingController(text: type?.contactName);
    }
  }

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

  ContactModel getData() {
    return ContactModel(
      type: value,
      value: _valueController.value.text,
      contactName: _nameController?.value.text,
    );
  }

  bool _checkPhone() {
    return value == ContactType.phone || value == ContactType.home_phone;
  }

  @override
  void dispose() {
    _valueController.dispose();
    _nameController?.dispose();
    super.dispose();
  }
}

class ContactTypePicker extends StatefulWidget {
  final String label;
  final ContactTypePickerController controller;

  const ContactTypePicker({super.key, required this.label, required this.controller});

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

  _handleClickType(BuildContext context) => () async {
        final types = ContactType.values;
        int initialIndex =
            types.indexWhere((t) => t == widget.controller.value);
        if (initialIndex < 0) initialIndex = 0;

        int selectedIndex = initialIndex;

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
                      child: Text('Cancel'.tr()),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    CupertinoButton(
                      child: Text('select'.tr()),
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
                        .map((t) => Center(child: Text(t.toString())))
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
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, ContactType contactType, Widget? child) {
        return Column(
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
                        Expanded(child: Text(contactType.toString())),
                        const Icon(Icons.keyboard_arrow_down_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.controller._valueController,
              decoration: InputDecoration(
                labelText: widget.controller.value.toString(),
                labelStyle: const TextStyle(fontSize: 18),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),
            if (widget.controller._nameController != null)
              TextField(
                controller: widget.controller._nameController,
                decoration: InputDecoration(
                  labelText: 'contact_name'.tr(),
                  labelStyle: const TextStyle(fontSize: 18),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
          ],
        );
      },
      valueListenable: widget.controller,
    );
  }
}
