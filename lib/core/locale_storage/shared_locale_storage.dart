import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorageImpl extends LocaleStorage {
  LocaleStorageImpl(this._pref);
  final SharedPreferences _pref;

  @override
  String? getString(String key) => _pref.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _pref.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async => _pref.getBool(key);

  @override
  Future<void> setBool(String key, bool value) => _pref.setBool(key, value);

  @override
  Future<void> remove(String key) async {
    await _pref.remove(key);
  }
}
