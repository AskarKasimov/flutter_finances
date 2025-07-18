import 'package:flutter_finances/domain/repositories/biometric_settings_repository.dart';

class IsBiometricEnabledUseCase {
  final BiometricSettingsRepository repository;

  IsBiometricEnabledUseCase({required this.repository});

  Future<bool> call() => repository.isBiometricEnabled();
}
