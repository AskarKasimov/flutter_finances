import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF2AE881);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  splashColor: Color(0x3300D68F),
  highlightColor: Color(0x1A00D68F),
  scaffoldBackgroundColor: const Color(0xFFFEF7FF),
  primaryColor: _primaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFF3EDF7),
    selectedItemColor: _primaryColor,
    unselectedItemColor: Color(0xFF49454F),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  colorScheme: const ColorScheme.light(
    primary: _primaryColor,
    secondary: Color(0xFFD4FAE6),
    error: Color(0xFFE46962),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  splashColor: Color(0x3300D68F),
  highlightColor: Color(0x1A00D68F),
  scaffoldBackgroundColor: const Color(0xFF121212),
  primaryColor: _primaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: _primaryColor,
    unselectedItemColor: Color(0xFF49454F),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  colorScheme: const ColorScheme.dark(
    primary: _primaryColor,
    secondary: Color(0xFFD4FAE6),
    error: Color(0xFFE46962),
  ),
);
