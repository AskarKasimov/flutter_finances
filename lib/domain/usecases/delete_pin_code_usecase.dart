import 'package:flutter_finances/domain/repositories/pin_code_storage.dart';

class DeletePinCodeUseCase {
  final PinCodeStorage _pinCodeStorage;

  DeletePinCodeUseCase(this._pinCodeStorage);

  Future<void> call() {
    return _pinCodeStorage.deletePinCode();
  }
}
