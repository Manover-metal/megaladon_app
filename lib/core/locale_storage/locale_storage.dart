// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

abstract class LocaleStorage {
  FutureOr<void> setString(String key, String value);

  FutureOr<String?> getString(String key);

  FutureOr<void> remove(String key);

  FutureOr<bool?> getBool(String key);

  FutureOr<void> setBool(String key, bool value);
}
