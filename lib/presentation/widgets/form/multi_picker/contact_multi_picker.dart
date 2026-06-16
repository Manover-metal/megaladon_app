import 'package:flutter/material.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/form/picker/dictionary/contact_picker.dart';

class ContactTypeMultiPickerController
    extends ValueNotifier<List<ContactTypePickerController>> {
  ContactTypeMultiPickerController({List<ContactModel>? contacts})
      : super(contacts != null
            ? contacts.map((e) => ContactTypePickerController(type: e)).toList()
            : []);

  void _listener() {
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
    for (final value in value) {
      value
        ..removeListener(_listener)
        ..dispose();
    }
    super.dispose();
  }
}

class ContactTypeMultiPicker extends StatefulWidget {
  const ContactTypeMultiPicker({required this.controller, super.key});
  final ContactTypeMultiPickerController controller;

  @override
  State<ContactTypeMultiPicker> createState() => _ContactTypeMultiPickerState();
}

class _ContactTypeMultiPickerState extends State<ContactTypeMultiPicker> {
  void _addContact() {
    widget.controller._addContactType(ContactTypePickerController());
  }

  Null Function() _removeByIndex(int index) => () {
        widget.controller._removeByIndex(index);
      };

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ValueListenableBuilder(
            valueListenable: widget.controller,
            builder: (context, contactTypes, child) => ListView.builder(
                itemCount: contactTypes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, item) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ContactTypePicker(
                              label: AppLocalizations.of(context)!.contact,
                              controller: widget.controller.value[item],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: IconButton(
                              onPressed: _removeByIndex(item),
                              icon: Icon(
                                Icons.remove_circle_outline_rounded,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
          ),
          OutlinedButtonApp(
            text: AppLocalizations.of(context)!.add_contact,
            onPressed: _addContact,
          )
        ],
      );
}
