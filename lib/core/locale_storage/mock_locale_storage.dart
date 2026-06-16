import 'package:megaladon/core/locale_storage/locale_storage.dart';

class MockLocaleStorage extends LocaleStorage {
  MockLocaleStorage();

  final Map<String, String> _storageStrings = {};
  final Map<String, bool> _storageBools = {};

  @override
  String? getString(String key) => _storageStrings[key];

  @override
  void setString(String key, String value) {
    _storageStrings[key] = value;
  }

  @override
  bool? getBool(String key) => _storageBools[key];

  @override
  void setBool(String key, bool value) {
    _storageBools[key] = value;
  }

  @override
  void remove(String key) {
    _storageStrings.remove(key);
    _storageBools.remove(key);
  }
}
