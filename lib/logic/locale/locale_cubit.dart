import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ru'));

  void change(Locale locale) => emit(locale);
}
