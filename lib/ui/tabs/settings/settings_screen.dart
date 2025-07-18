import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_finances/domain/usecases/get_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/is_biometric_enabled_usecase.dart';
import 'package:flutter_finances/domain/usecases/save_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/set_biometric_enabled_usecase.dart';
import 'package:flutter_finances/ui/tabs/settings/pin_code_screen.dart';
import 'package:flutter_finances/ui/theme/theme_controller.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = false;
  bool _loading = true;
  bool _hasPin = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isBiometricEnabled = await context
        .read<IsBiometricEnabledUseCase>()();
    final pin = await context.read<GetPinCodeUseCase>()();
    setState(() {
      _biometricEnabled = isBiometricEnabled;
      _hasPin = pin != null && pin.isNotEmpty;
      _loading = false;
    });
  }

  void _toggleBiometric(bool value) async {
    if (!_hasPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала установите пин-код')),
      );
      return;
    }

    final setUseCase = context.read<SetBiometricEnabledUseCase>();
    await setUseCase(value);
    setState(() {
      _biometricEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                        setBiometricEnabledUseCase: context
                            .read<SetBiometricEnabledUseCase>(),
                      ),
                    ),
                  );
                  if (result == true) {
                    // Перезагрузить флаг наличия PIN
                    final pin = await context.read<GetPinCodeUseCase>()();
                    final biometricEnabled = await context
                        .read<IsBiometricEnabledUseCase>()();
                    setState(() {
                      _hasPin = pin != null && pin.isNotEmpty;
                      _biometricEnabled = biometricEnabled;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Биометрия'),
                trailing: Switch(
                  value: _biometricEnabled,
                  onChanged: _toggleBiometric,
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    return !_hasPin ? Colors.grey : null;
                  }),
                ),
                onTap: () {
                  if (!_hasPin) {
                    _toggleBiometric(false);
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
