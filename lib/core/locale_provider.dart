import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/main.dart';
import 'package:pchr/screens/dashboard/dashboard.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    loadLanguage();
  }

  Locale _locale = Locale('en');
  Map<String, String> _localizedStrings = {};

  Locale get locale => _locale;

  Future<void> loadLanguage() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${_locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    notifyListeners();
  }

  Future<void> setLocale(Locale locale, [bool onStartup = false]) async {
    if (_locale == locale) return;

    _locale = locale;
    await loadLanguage();

    await storeLanguage(locale.languageCode, locale.countryCode ?? 'pk');

    if (!onStartup) {
      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Dashboard(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  Future<void> storeLanguage(String language, String country) async {
    await languageBox.putAll({
      'locale': '${language}_$country',
      'language_code': language,
      'country_code': country,
    });
  }
}
