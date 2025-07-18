import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF2AE881);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  splashColor: const Color(0x3300D68F),
  highlightColor: const Color(0x1A00D68F),
  scaffoldBackgroundColor: const Color(0xFFFEF7FF),
  appBarTheme: const AppBarTheme(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(color: Color(0xFF1D1B20), fontSize: 22),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF49454F)),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color(0xFFF3EDF7),
  ),
  colorScheme: const ColorScheme.light(
    primary: _primaryColor,
    secondary: Color(0xFFD4FAE6),
    error: Color(0xFFE46962),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF1D1B20), fontSize: 16),
    bodySmall: TextStyle(color: Color(0xFF1D1B20), fontSize: 13),
  ),
  iconTheme: const IconThemeData(color: Color(0x3C3C434D)),
  dividerColor: const Color(0xFFCAC4D0),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xFFECE6F0),
  ),
  hintColor: const Color(0xFF49454F),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  splashColor: const Color(0x33FFFFFF),
  highlightColor: const Color(0x1AFFFFFF),
  scaffoldBackgroundColor: const Color(0xFF121212),
  primaryColor: _primaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
    iconTheme: IconThemeData(color: Colors.white70),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    indicatorColor: _primaryColor,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(color: Colors.white, fontSize: 12),
    ),
    iconTheme: WidgetStatePropertyAll(IconThemeData(color: Colors.white70)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    selectedItemColor: _primaryColor,
    unselectedItemColor: Colors.white38,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  colorScheme: const ColorScheme.dark(
    primary: _primaryColor,
    secondary: Color(0xFF2AE881),
    surface: Color(0xFF1E1E1E),
    error: Color(0xFFE46962),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white70, fontSize: 13),
  ),
  iconTheme: const IconThemeData(color: Colors.white60),
  dividerColor: Colors.white10,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xFF1E1E1E),
    filled: true,
    hintStyle: TextStyle(color: Colors.white38),
    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
  ),
  hintColor: Colors.white38,
);
