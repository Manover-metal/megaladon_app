import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';

const _kLocaleKey = 'locale';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ru')) {
    _loadSaved();
  }

  final LocaleStorage _storage = getItApp<LocaleStorage>();

  Future<void> _loadSaved() async {
    final code = await _storage.getString(_kLocaleKey);
    if (code != null) {
      final locale = Locale(code);
      ApiService.setLocale(locale);
      emit(locale);
    }
  }

  void change(Locale locale) {
    _storage.setString(_kLocaleKey, locale.languageCode);
    ApiService.setLocale(locale);
    emit(locale);
  }
}
