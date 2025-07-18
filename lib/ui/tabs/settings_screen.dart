import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/theme/theme_controller.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки'), centerTitle: true),
      body: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Использовать системную тему'),
                value: themeController.useSystemTheme,
                onChanged: (value) {
                  themeController.updateUseSystemTheme(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
