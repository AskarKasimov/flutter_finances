import 'package:flutter_finances/domain/repositories/pin_code_storage.dart';

class GetPinCodeUseCase {
  final PinCodeStorage _pinCodeStorage;

  GetPinCodeUseCase(this._pinCodeStorage);

  Future<String?> call() {
    return _pinCodeStorage.getPinCode();
  }
}
