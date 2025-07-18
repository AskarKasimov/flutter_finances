import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const _key = 'useSystemTheme';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final useSystem = prefs.getBool(_key) ?? true;
    _themeMode = useSystem ? ThemeMode.system : ThemeMode.light;
    notifyListeners();
  }

  Future<void> updateUseSystemTheme(bool useSystem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, useSystem);
    _themeMode = useSystem ? ThemeMode.system : ThemeMode.light;
    print('>>> Updated themeMode: $_themeMode');
    notifyListeners();
  }

  bool get useSystemTheme => _themeMode == ThemeMode.system;
}
