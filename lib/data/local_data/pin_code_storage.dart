import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class PinCodeStorage {
  Future<void> savePinCode(String pinCode);

  Future<String?> getPinCode();

  Future<void> deletePinCode();
}

class SecurePinCodeStorage implements PinCodeStorage {
  final FlutterSecureStorage _secureStorage;

  static const _pinCodeKey = 'pin_code_key';

  SecurePinCodeStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> savePinCode(String pinCode) async {
    await _secureStorage.write(key: _pinCodeKey, value: pinCode);
  }

  @override
  Future<String?> getPinCode() async {
    return await _secureStorage.read(key: _pinCodeKey);
  }

  @override
  Future<void> deletePinCode() async {
    await _secureStorage.delete(key: _pinCodeKey);
  }
}
