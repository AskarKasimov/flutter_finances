import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/navigation/tab_screen_interface.dart';

class SettingsScreen extends StatelessWidget implements TabScreen {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('экран с настройками'));
  }

  @override
  IconData get tabIcon => Icons.settings_outlined;

  @override
  String get tabLabel => 'Настройки';

  @override
  AppBar get appBar =>
      AppBar(title: const Text('Настройки'), centerTitle: true);
}
