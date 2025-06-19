abstract class TransactionHistoryEvent {}

class LoadTransactionHistory extends TransactionHistoryEvent {
  final DateTime startDate;
  final DateTime endDate;

  LoadTransactionHistory({required this.startDate, required this.endDate});
}
