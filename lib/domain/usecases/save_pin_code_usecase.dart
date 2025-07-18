import 'package:flutter_finances/domain/repositories/pin_code_storage.dart';

class SavePinCodeUseCase {
  final PinCodeStorage _pinCodeStorage;

  SavePinCodeUseCase(this._pinCodeStorage);

  Future<void> call(String pinCode) {
    return _pinCodeStorage.savePinCode(pinCode);
  }
}
