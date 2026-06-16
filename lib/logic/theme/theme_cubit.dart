import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';

const _kThemeKey = 'theme_mode';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark) {
    _loadSaved();
  }

  final LocaleStorage _storage = getItApp<LocaleStorage>();

  Future<void> _loadSaved() async {
    final value = await _storage.getString(_kThemeKey);
    if (value != null) {
      emit(_fromString(value));
    }
  }

  void change(ThemeMode mode) {
    _storage.setString(_kThemeKey, _toString(mode));
    emit(mode);
  }

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }

  static ThemeMode _fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
}
