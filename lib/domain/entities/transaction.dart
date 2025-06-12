class Transaction {
  final int _id;
  final int _accountId;
  final int? _categoryId;
  final double _amount;
  final DateTime _timestamp;
  final String? _comment;

  Transaction({
    required int id,
    required int accountId,
    required int? categoryId,
    required double amount,
    required DateTime timestamp,
    required String? comment,
  }) : _id = id,
       _accountId = accountId,
       _categoryId = categoryId,
       _amount = amount,
       _timestamp = timestamp,
       _comment = comment;
}
