import 'package:flutter_finances/data/local_data/pin_code_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurePinCodeStorage implements PinCodeStorage {
  final FlutterSecureStorage _secureStorage;

  static const _pinCodeKey = 'user_pin_code';

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
