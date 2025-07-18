import 'package:flutter_finances/data/local_data/pin_code_storage.dart';

class SavePinCodeUseCase {
  final PinCodeStorage _pinCodeStorage;

  SavePinCodeUseCase(this._pinCodeStorage);

  Future<void> call(String pinCode) {
    return _pinCodeStorage.savePinCode(pinCode);
  }
}
