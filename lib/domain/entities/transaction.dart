class Transaction {
  final int id;
  final int accountId;
  final int categoryId;
  final double amount;
  final DateTime timestamp;
  final String? comment;

  Transaction({
    required this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.timestamp,
    required this.comment,
  });
}
