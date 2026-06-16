import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';

class SecureLocaleStorageImpl extends LocaleStorage {
  SecureLocaleStorageImpl() : _storage = const FlutterSecureStorage();
  final FlutterSecureStorage _storage;

  @override
  Future<String?> getString(String key) => _storage.read(key: key);

  @override
  Future<void> setString(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<bool?> getBool(String key) async =>
      _boolFromString(await _storage.read(key: key));

  @override
  Future<void> setBool(String key, bool value) =>
      _storage.write(key: key, value: value.toString());

  @override
  Future<void> remove(String key) => _storage.delete(key: key);

  bool? _boolFromString(String? value) {
    if (value == null) return null;
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;
    return null;
  }
}
