import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/usecases/get_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/is_biometric_enabled_usecase.dart';
import 'package:flutter_finances/domain/usecases/save_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/set_biometric_enabled_usecase.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/tabs/settings/pin_code_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class PinCheckScreen extends StatefulWidget {
  const PinCheckScreen({super.key});

  @override
  State<PinCheckScreen> createState() => _PinCheckScreenState();
}

class _PinCheckScreenState extends State<PinCheckScreen> {
  bool _loading = true;
  bool _showPin = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final getPinUseCase = context.read<GetPinCodeUseCase>();
    final isBiometricEnabled = await context
        .read<IsBiometricEnabledUseCase>()();
    final savedPin = await getPinUseCase();

    final hasPin = savedPin != null && savedPin.isNotEmpty;

    if (isBiometricEnabled) {
      final auth = LocalAuthentication();
      final canUseBiometrics = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();

      if (canUseBiometrics && isSupported) {
        try {
          final didAuth = await auth.authenticate(
            localizedReason: AppLocalizations.of(context)!.biometricAuthReason,
            options: const AuthenticationOptions(biometricOnly: true),
          );

          if (didAuth) {
            if (!mounted) return;
            Future.microtask(() => context.replace('/expenses'));
            return;
          }
        } catch (_) {
          // игнорируем, идём дальше
        }
      }
    }

    if (hasPin) {
      if (!mounted) return;
      setState(() {
        _showPin = true;
        _loading = false;
      });
    } else {
      if (!mounted) return;
      Future.microtask(() => context.replace('/expenses'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_showPin) {
      return PinCodeScreen(
        mode: PinCodeMode.enter,
        getPinCodeUseCase: context.read<GetPinCodeUseCase>(),
        savePinCodeUseCase: context.read<SavePinCodeUseCase>(),
        setBiometricEnabledUseCase: context.read<SetBiometricEnabledUseCase>(),
      );
    }

    return const Scaffold(); // сюда не должно дойти.
  }
}
