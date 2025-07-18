import 'package:flutter/material.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const _localeKey = 'localeCode';

  Locale? _locale;

  Locale? get locale => _locale;

  String localeDisplayName(BuildContext context, Locale? locale) {
    final loc = AppLocalizations.of(context)!;

    if (locale == null) return loc.languageSystem;

    switch (locale.languageCode) {
      case 'en':
        return loc.languageEnglish;
      case 'ru':
        return loc.languageRussian;
      default:
        return locale.languageCode;
    }
  }


  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null && localeCode.isNotEmpty) {
      _locale = Locale(localeCode);
    } else {
      _locale = null; // null значит системная локаль
    }
    notifyListeners();
  }

  Future<void> updateLocale(Locale? newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    if (newLocale == null) {
      await prefs.remove(_localeKey);
      _locale = null;
    } else {
      await prefs.setString(_localeKey, newLocale.languageCode);
      _locale = newLocale;
    }
    notifyListeners();
  }
}
