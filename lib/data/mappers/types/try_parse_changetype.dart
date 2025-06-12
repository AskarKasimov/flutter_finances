import 'package:dartz/dartz.dart';
import 'package:flutter_finances/domain/entities/enums/change_type.dart';
import 'package:flutter_finances/domain/failures/failure.dart';
import 'package:flutter_finances/domain/failures/parsing_failure.dart';

Either<Failure, ChangeType> tryParseChangeType(
  String source,
  String fieldName,
) {
  try {
    return right(ChangeType.values.byName(source));
  } catch (_) {
    return left(
      ParsingFailure('Неизвестный ChangeType: "$source" в поле $fieldName'),
    );
  }
}
