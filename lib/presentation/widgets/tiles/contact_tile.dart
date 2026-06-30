import 'package:flutter/material.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/snackbars/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({required this.contact, super.key});
  final ContactModel contact;

  IconData get _icon {
    switch (contact.type) {
      case ContactType.phone:
        return Icons.phone;
      case ContactType.home_phone:
        return Icons.phone_in_talk;
      case ContactType.email:
        return Icons.email_outlined;
      case ContactType.site:
        return Icons.language;
    }
  }

  Uri get _uri {
    switch (contact.type) {
      case ContactType.phone:
      case ContactType.home_phone:
        return Uri(scheme: 'tel', path: contact.value);
      case ContactType.email:
        return Uri(scheme: 'mailto', path: contact.value);
      case ContactType.site:
        final value = contact.value;
        if (value.startsWith('http://') || value.startsWith('https://')) {
          return Uri.parse(value);
        }
        return Uri.parse('https://$value');
    }
  }

  Future<void> _launch(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    var opened = false;
    try {
      if (await canLaunchUrl(_uri)) {
        opened = await launchUrl(_uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      opened = false;
    } finally {
      if (!opened && context.mounted) {
        CustomSnackBar.error(Text(l10n.failed_to_open_contact)).view(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = contact.contactName;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => _launch(context),
      leading: Icon(_icon, color: theme.colorScheme.primary),
      title: Text(
        contact.value,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      subtitle: name != null && name.isNotEmpty ? Text(name) : null,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
