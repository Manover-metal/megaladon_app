import 'package:megaladon/generated/l10n/app_localizations.dart';

enum ContactType {
  phone,
  home_phone,
  site,
  email;

  static ContactType parse(String data) {
    switch (data) {
      case 'phone':
        {
          return phone;
        }
      case 'home_phone':
        {
          return home_phone;
        }
      case 'site':
        {
          return site;
        }
      case 'email':
        {
          return email;
        }
      default:
        return site;
    }
  }

  String localize(AppLocalizations l10n) {
    switch (this) {
      case ContactType.phone:
        return l10n.mobile_phone;
      case ContactType.home_phone:
        return l10n.home_phone;
      case ContactType.site:
        return l10n.website;
      case ContactType.email:
        return l10n.email;
      default:
        return l10n.additional_data;
    }
  }
}

class ContactModel {
  ContactModel({required this.type, required this.value, this.contactName});
  final String value;
  final ContactType type;
  final String? contactName;

  static ContactModel fromJson(data) {
    print(data);
    return ContactModel(
        type: ContactType.parse(data['type'] as String),
        value: data['value'] as String,
        contactName: data['contact_name'] as String?);
  }

  static List<ContactModel> fromJsonList(List<dynamic> data) => data
      .map<ContactModel>(
          (item) => ContactModel.fromJson(item as Map<String, dynamic>))
      .toList();

  static ContactModel get nothing =>
      ContactModel(value: '', contactName: '', type: ContactType.phone);
}
