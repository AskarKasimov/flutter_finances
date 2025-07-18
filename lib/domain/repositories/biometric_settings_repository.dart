abstract class BiometricSettingsRepository {
  Future<bool> isBiometricEnabled();

  Future<void> setBiometricEnabled(bool enabled);
}
