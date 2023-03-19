import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:megaladon/data/models/contact_model.dart';

Future<List<int>?> showContactTypePicker(BuildContext context) async {
  return await Picker(
    itemExtent: 30,
    height: MediaQuery.of(context).size.height / 3.5,
    backgroundColor: Theme.of(context).colorScheme.background,
    adapter: PickerDataAdapter<ContactType>(
        data: ContactType.values.map((type) {
          return PickerItem<ContactType>(
              text: Text(type.toString()),
              value: type
          );
        }).toList()
    ),
    changeToFirst: false,
    hideHeader: false,
    cancelText: 'Отмена',
    confirmText: 'Выбрать',
  ).showModal(context);
}


class ContactTypePickerController extends ValueNotifier<ContactType> {
  late TextEditingController _valueController;
  TextEditingController? _nameController;

  ContactTypePickerController({ ContactType type = ContactType.phone}) : super(type) {
    _valueController = TextEditingController();
    _nameController = TextEditingController();
  }

  void _changeContactType(ContactType type) {
    value = type;

    _valueController.dispose();
    _nameController?.dispose();

    _valueController = TextEditingController();
    if(value == ContactType.phone || value == ContactType.homePhone) {
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
      contactName: _nameController?.value.text
    );
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

  _handleClickType(BuildContext context) => () async {
    List<int>? result = await showContactTypePicker(context);
    try{
      if (result != null) {
        ContactType contactType = ContactType.values[result[0]];
        widget.controller._changeContactType(contactType);
        _textController.value = TextEditingValue(text: contactType.toString());
      }
    }catch (e) {}
    FocusManager.instance.primaryFocus?.unfocus();
  };

  @override
  void initState() {
    _textController = TextEditingController(text: widget.controller.value.toString());
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ContactTypePicker oldWidget) {
    if(oldWidget.controller.value != widget.controller.value) {
      _textController.dispose();
      _textController = TextEditingController(text: widget.controller.value.toString());
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, ContactType contactType, Widget? child) {
        return Column(
          children: [
            TextField(
              controller: _textController,
              onTap: _handleClickType(context),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: const TextStyle(
                    fontSize: 18
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10)
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.controller._valueController,
              decoration: InputDecoration(
                  labelText: widget.controller.value.toString(),
                  labelStyle: const TextStyle(
                      fontSize: 18
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10)
              ),
            ),
            const SizedBox(height: 10),
            if(widget.controller._nameController != null) TextField(
              controller: widget.controller._nameController,
              decoration: const InputDecoration(
                  labelText: "Имя контакта",
                  labelStyle: TextStyle(
                      fontSize: 18
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10)
              ),
            ),
          ],
        );
      },
      valueListenable: widget.controller,
    );
  }
}