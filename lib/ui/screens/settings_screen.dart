import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/navigation/tab.dart';

class SettingsScreen extends StatelessWidget implements TabScreen {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Настройки'));
  }

  @override
  IconData get tabIcon => Icons.settings_outlined;

  @override
  String get tabLabel => "Настройки";
}
