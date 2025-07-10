import 'package:flutter_finances/domain/entities/enums/change_type.dart';

ChangeType tryParseChangeType(String source, String fieldName) {
  try {
    return ChangeType.values.byName(source);
  } catch (e) {
    throw ArgumentError(
      'Invalid value for $fieldName: $source. '
      'Expected one of: ${ChangeType.values.map((e) => e.name).join(', ')}',
    );
  }
}
