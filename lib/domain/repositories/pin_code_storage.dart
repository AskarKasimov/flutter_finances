abstract class PinCodeStorage {
  Future<void> savePinCode(String pinCode);

  Future<String?> getPinCode();

  Future<void> deletePinCode();
}
