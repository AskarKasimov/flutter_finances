import 'package:dartz/dartz.dart';
import 'package:flutter_finances/data/models/transaction_request/transaction_request.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

extension TransactionFormMapper on TransactionForm {
  Either<Failure, TransactionRequestDTO> toDTO() {
    return right(
      TransactionRequestDTO(
        accountId: accountId,
        categoryId: categoryId,
        amount: amount?.toString(),
        transactionDate: timestamp.toString(),
        comment: comment,
      ),
    );
  }
}
