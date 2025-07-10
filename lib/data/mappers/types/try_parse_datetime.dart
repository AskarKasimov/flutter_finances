DateTime tryParseDateTime(String source, String fieldName) {
  final result = DateTime.tryParse(source);
  if (result == null) {
    throw FormatException('Invalid date format for $fieldName: "$source".');
  }
  return result;
}
