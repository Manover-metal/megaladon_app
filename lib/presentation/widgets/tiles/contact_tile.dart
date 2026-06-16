import 'package:flutter/material.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/form/field/text_field.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({required this.contact, super.key});
  final ContactModel contact;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            TextFieldApp(
              label: contact.type.localize(AppLocalizations.of(context)!),
              value: contact.value,
              readOnly: true,
            ),
            if (contact.contactName != null)
              TextFieldApp(
                value: contact.contactName,
                readOnly: true,
              ),
          ],
        ),
      );
}
