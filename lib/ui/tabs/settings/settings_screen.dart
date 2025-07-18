import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_finances/domain/usecases/get_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/save_pin_code_usecase.dart';
import 'package:flutter_finances/ui/tabs/settings/pin_code_screen.dart';
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
              ListTile(
                title: const Text('Основной цвет (тинт)'),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: themeController.tintColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                onTap: () async {
                  Color pickedColor = themeController.tintColor;

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Выберите основной цвет'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickedColor,
                            onColorChanged: (color) {
                              pickedColor = color;
                            },
                            enableAlpha: false,
                            labelTypes: [],
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              themeController.updateTintColor(pickedColor);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Выбрать'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                title: const Text('Пин-код'),
                onTap: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PinCodeScreen(
                        mode: PinCodeMode.set,
                        savePinCodeUseCase: context.read<SavePinCodeUseCase>(),
                        getPinCodeUseCase: context.read<GetPinCodeUseCase>(),
                      ),
                    ),
                  );
                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Пин-код успешно установлен'),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
