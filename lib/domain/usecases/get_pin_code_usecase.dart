import 'package:flutter_finances/data/local_data/pin_code_storage.dart';

class GetPinCodeUseCase {
  final PinCodeStorage _pinCodeStorage;

  GetPinCodeUseCase(this._pinCodeStorage);

  Future<String?> call() {
    return _pinCodeStorage.getPinCode();
  }
}
