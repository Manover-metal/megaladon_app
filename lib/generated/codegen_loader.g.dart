// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "main_screen": "Main Screen",
  "element": "Element",
  "project": "Project",
  "product": "Product",
  "category": "Category",
  "create": "Create",
  "update": "Update",
  "add_title": "Add {}",
  "create_title": "Create {}",
  "update_title": "Update {}",
  "name_field": "Name {}*",
  "description_field": "Description {}",
  "type": "Type",
  "Edit": "Edit",
  "Delete": "Delete",
  "Copy": "Copy",
  "Cut": "Cut",
  "Orders": "Orders"
};
static const Map<String,dynamic> ru = {
  "main_screen": "Главная",
  "element": "Элемент",
  "project": "Проект",
  "product": "Продукт",
  "category": "Категория",
  "create": "Создать",
  "update": "Изменить",
  "add_title": "Добавить {}",
  "create_title": "Cоздать {}",
  "update_title": "Изменить {}",
  "name_field": "Название {}*",
  "description_field": "Описание {}",
  "type": "Тип",
  "Edit": "Изменить",
  "Delete": "Удалить",
  "Copy": "Копировать",
  "Cut": "Вставить",
  "Orders": "Заказы"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ru": ru};
}
