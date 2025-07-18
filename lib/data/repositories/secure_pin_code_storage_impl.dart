import 'package:flutter_finances/domain/repositories/pin_code_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurePinCodeStorageImpl implements PinCodeStorage {
  final FlutterSecureStorage _secureStorage;

  static const _pinCodeKey = 'pin_code_key';

  SecurePinCodeStorageImpl({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

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