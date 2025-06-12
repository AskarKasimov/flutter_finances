import 'package:dartz/dartz.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/models/stat_item/stat_item.dart';
import 'package:flutter_finances/domain/entities/stat_item.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

extension StatItemMapper on StatItemDTO {
  Either<Failure, StatItem> toDomain() {
    final amountOrFailure = tryParseDouble(amount, 'amount');

    return amountOrFailure.map(
      (parsedAmount) => StatItem(
        categoryId: categoryId,
        categoryName: categoryName,
        emoji: emoji,
        amount: parsedAmount,
      ),
    );
  }
}
