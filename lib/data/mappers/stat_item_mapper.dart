import 'package:flutter_finances/data/mappers/types/try_parse_double.dart';
import 'package:flutter_finances/data/models/stat_item/stat_item.dart';
import 'package:flutter_finances/domain/entities/stat_item.dart';

extension StatItemMapper on StatItemDTO {
  StatItem toDomain() {
    final parsedAmount = tryParseDouble(amount, 'amount');

    return StatItem(
      categoryId: categoryId,
      categoryName: categoryName,
      emoji: emoji,
      amount: parsedAmount,
    );
  }
}
