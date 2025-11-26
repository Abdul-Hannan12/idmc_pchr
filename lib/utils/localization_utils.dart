import 'package:flutter/material.dart';
import 'package:pchr/core/locale_provider.dart';
import 'package:provider/provider.dart';

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return Provider.of<LocaleProvider>(this, listen: false).translate(key);
  }

  Future<void> setLocale(Locale locale, [bool onStartup = false]) async {
    await Provider.of<LocaleProvider>(this, listen: false)
        .setLocale(locale, onStartup);
  }

  Future<void> toggleLocale() async {
    final currentLocale =
        Provider.of<LocaleProvider>(this, listen: false).locale;
    await Provider.of<LocaleProvider>(this, listen: false).setLocale(
      Locale(currentLocale.languageCode == 'en' ? 'ur' : 'en'),
    );
  }
}
