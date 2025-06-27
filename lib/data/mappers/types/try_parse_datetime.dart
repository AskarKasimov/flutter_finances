DateTime tryParseDateTime(String source, String fieldName) {
  try {
    return DateTime.parse(source);
  } catch (e) {
    throw FormatException('Invalid date format for $fieldName: "$source".');
  }
}
