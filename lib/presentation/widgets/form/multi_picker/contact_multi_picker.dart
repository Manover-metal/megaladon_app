import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/contact_picker.dart';

class ContactTypeMultiPickerController extends ValueNotifier<List<ContactTypePickerController>> {
  ContactTypeMultiPickerController({List<ContactTypePickerController>? contacts }) : super(contacts ?? []);

  _listener() {
    notifyListeners();
  }

  void _addContactType(ContactTypePickerController controller) {
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

class ContactTypeMultiPicker extends StatefulWidget {
  final ContactTypeMultiPickerController controller;

  const ContactTypeMultiPicker({super.key, required this.controller});

  @override
  State<ContactTypeMultiPicker> createState() => _ContactTypeMultiPickerState();
}

class _ContactTypeMultiPickerState extends State<ContactTypeMultiPicker> {
  _addContact() {
    widget.controller._addContactType(ContactTypePickerController());
  }

  _removeByIndex(int index) => () {
    widget.controller._removeByIndex(index);
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, List<ContactTypePickerController> contactTypes, Widget? child) {
            return ListView.builder(
                itemCount: contactTypes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ContactTypePicker(
                            label: 'Контакт',
                            controller: widget.controller.value[item],
                          ),
                        ),
                        IconButton(
                          onPressed: _removeByIndex(item),
                          icon: Icon(Icons.remove_circle_outline_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      ],
                    ),
                  );
                }
            );
          },
        ),
        OutlinedButtonApp(text: 'Добавить Контакт', onPressed: _addContact,)
      ],
    );
  }
}