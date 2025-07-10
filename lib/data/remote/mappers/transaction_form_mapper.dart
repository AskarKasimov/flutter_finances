import 'package:flutter_finances/data/remote/models/transaction_request/transaction_request.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';

extension TransactionFormMapper on TransactionForm {
  TransactionRequestDTO toDTO() {
    return TransactionRequestDTO(
      accountId: accountId,
      categoryId: categoryId,
      amount: amount.toString(),
      transactionDate: timestamp.toString(),
      comment: comment,
    );
  }
}
