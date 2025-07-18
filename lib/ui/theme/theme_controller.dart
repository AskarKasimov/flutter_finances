import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const _useSystemKey = 'useSystemTheme';
  static const _tintColorKey = 'tintColor';

  ThemeMode _themeMode = ThemeMode.system;
  Color _tintColor = const Color(0xFF2AE881);

  ThemeMode get themeMode => _themeMode;

  Color get tintColor => _tintColor;

  bool get useSystemTheme => _themeMode == ThemeMode.system;

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final useSystem = prefs.getBool(_useSystemKey) ?? true;
    _themeMode = useSystem ? ThemeMode.system : ThemeMode.light;

    final tintColorValue = prefs.getInt(_tintColorKey);
    if (tintColorValue != null) {
      _tintColor = Color(tintColorValue);
    }

    notifyListeners();
  }

  Future<void> updateUseSystemTheme(bool useSystem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useSystemKey, useSystem);
    _themeMode = useSystem ? ThemeMode.system : ThemeMode.light;
    notifyListeners();
  }

  Future<void> updateTintColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tintColorKey, color.toARGB32());
    _tintColor = color;
    notifyListeners();
  }
}
