import 'package:dartz/dartz.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

abstract interface class CategoryRepository {
  Future<Either<Failure, List<Category>>> getAllCategories();

  Future<Either<Failure, List<Category>>> getCategoriesByIsIncome(
    bool isIncome,
  );
}
