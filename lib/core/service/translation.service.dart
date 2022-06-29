import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../shared/constants/app_languages.dart';

class TranslationService extends GetConnect {
  static final List<String> supportedLocales = <String>[
    AppLanguages.en,
    AppLanguages.fr,
    AppLanguages.ar,
    AppLanguages.es,
    AppLanguages.it,

  ];


  Future<AppTranslations> getTranslations() async {
    final AppTranslations appTranslations =
        AppTranslations(translationKeys: <String, Map<String, String>>{});
    for (final String supportedLocale in supportedLocales) {
      final Map<String, String> entries = <String, String>{};
      final dynamic jsonData = json.decode(await rootBundle
          .loadString('assets/i18n/' + supportedLocale + '.json'));

      jsonData.forEach((String key, dynamic embedded) {
        embedded.forEach((String subKey, dynamic value) {
          entries.putIfAbsent(key + '.' + subKey, () => value.toString());
        });
      });

      appTranslations.append(supportedLocale, entries);
    }
    return appTranslations;
  }
}

class AppTranslations extends Translations {
  AppTranslations({required this.translationKeys});

  final Map<String, Map<String, String>> translationKeys;

  void append(String locale, Map<String, String> json) {
    translationKeys.putIfAbsent(locale, () => json);
  }

  @override
  Map<String, Map<String, String>> get keys => translationKeys;
}
