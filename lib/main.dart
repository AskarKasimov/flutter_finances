import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/navigation/navbar.dart';
import 'package:flutter_finances/ui/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Finance',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: MainTabBar(),
    );
  }
}
