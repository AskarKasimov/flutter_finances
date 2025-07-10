double tryParseDouble(String source, String fieldName) {
  final value = double.tryParse(source);
  if (value == null || value.isNaN || value.isInfinite) {
    throw FormatException('Invalid double value for $fieldName');
  }
  return value;
}
