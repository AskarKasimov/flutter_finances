import 'package:dartz/dartz.dart';
import 'package:flutter_finances/data/models/category/category.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

extension CategoryMapper on CategoryDTO {
  Either<Failure, Category> toDomain() {
    return right(
      Category(id: this.id, name: name, emoji: emoji, isIncome: isIncome),
    );
  }
}
