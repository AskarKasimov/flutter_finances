double tryParseDouble(String source, String fieldName) {
  try {
    final value = double.parse(source);
    if (value.isNaN || value.isInfinite) {
      throw FormatException('Invalid double value for $fieldName');
    }
    return value;
  } catch (e) {
    throw FormatException(
      'Error parsing $fieldName: $source. Must be a valid float number.',
    );
  }
}
