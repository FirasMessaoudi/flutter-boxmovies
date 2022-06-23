import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MyTheme {

  final GetStorage _store = GetStorage();

  ThemeMode currentMode() {
    return isDark? ThemeMode.dark : ThemeMode.light;
  }


  Future<void> switchTheme() {
    return _store.write('theme', !isDark);

  }

  bool get isDark {
    return _store.read('theme')??true;
  }

  String get language {
    return _store.read('language')??'en';

  }

  Locale get currentLocale {
    return Locale(language);
  }

  Future<void> switchLanguage(String languageCode) {
    return _store.write('language', languageCode);

  }


}
