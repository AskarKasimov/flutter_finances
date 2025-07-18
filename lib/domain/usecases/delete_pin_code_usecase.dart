import 'package:flutter_finances/data/local_data/pin_code_storage.dart';

class DeletePinCodeUseCase {
  final PinCodeStorage _pinCodeStorage;

  DeletePinCodeUseCase(this._pinCodeStorage);

  Future<void> call() {
    return _pinCodeStorage.deletePinCode();
  }
}
