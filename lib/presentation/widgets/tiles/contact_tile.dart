import 'package:flutter/material.dart';
import 'package:megaladon/data/models/contact_model.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({required this.contact, super.key});
  final ContactModel contact;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                contact.type.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18),
              ),
            ),
            Expanded(
              child: Text(
                contact.value,
                textAlign: TextAlign.right,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 18),
              ),
            )
          ],
        ),
      );
}
