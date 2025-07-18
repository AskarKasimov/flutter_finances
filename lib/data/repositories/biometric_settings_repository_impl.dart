import 'package:flutter_finances/domain/repositories/biometric_settings_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricSettingsRepositoryImpl implements BiometricSettingsRepository {
  final FlutterSecureStorage _secureStorage;

  static const _key = 'biometric_enabled';

  BiometricSettingsRepositoryImpl({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  @override
  Future<bool> isBiometricEnabled() async {
    final String? value = await _secureStorage.read(key: _key);
    if (value == null) {
      return false;
    }
    return value.toLowerCase() == 'true';
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(key: _key, value: enabled.toString());
  }
}
