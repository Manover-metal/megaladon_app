import 'package:easy_localization/easy_localization.dart';

enum ContactType {
  phone, home_phone, site, email;

  static ContactType parse(String data) {
    switch(data) {
      case 'phone': {
        return phone;
      } case 'home_phone': {
        return home_phone;
      } case 'site': {
        return site;
      } case 'email': {
        return email;
      }
      default: return site;
    }
  }

  @override
  String toString() {
    switch(this) {
      case phone: {
        return 'Mobile_phone'.tr();
      } case home_phone: {
        return 'Home_phone'.tr();
      } case site: {
        return 'Website'.tr();
      } case email: {
        return 'Email'.tr();
      }
      default: return 'Additional_data'.tr();
    }
  }
}

class ContactModel {
  final String value;
  final ContactType type;
  final String? contactName;

  ContactModel({
    required this.type,
    required this.value,
    this.contactName
  });

  static ContactModel fromJson(data) {
    print(data);
    return ContactModel(
        type: ContactType.parse(data['type']),
        value: data['value'],
        contactName: data['contact_name']
    );
  }

  static List<ContactModel> fromJsonList(data) {
    return data.map<ContactModel>((e) {
      return ContactModel.fromJson(e);
    }).toList();
  }

  static ContactModel get nothing => ContactModel(value: '', contactName: '', type: ContactType.phone);

}