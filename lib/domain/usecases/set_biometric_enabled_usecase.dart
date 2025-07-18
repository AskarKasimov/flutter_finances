import 'package:flutter_finances/domain/repositories/biometric_settings_repository.dart';

class SetBiometricEnabledUseCase {
  final BiometricSettingsRepository repository;

  SetBiometricEnabledUseCase({required this.repository});

  Future<void> call(bool enabled) => repository.setBiometricEnabled(enabled);
}
