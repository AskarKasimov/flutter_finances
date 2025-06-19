import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period.dart';

import 'transactions_history_event.dart';
import 'transactions_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final GetTransactionsByPeriod getTransactions;
  final bool isIncome;

  TransactionHistoryBloc({
    required this.getTransactions,
    required this.isIncome,
    required DateTime startDate,
    required DateTime endDate,
  }) : super(
         TransactionHistoryLoading(startDate: startDate, endDate: endDate),
       ) {
    on<LoadTransactionHistory>(_onLoadTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactionHistory event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(
      TransactionHistoryLoading(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    final result = await getTransactions(
      startDate: event.startDate,
      endDate: event.endDate,
      isIncome: isIncome,
    );

    result.fold(
      (failure) => emit(
        TransactionHistoryError(
          message: failure.message,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      ),
      (transactions) => emit(
        TransactionHistoryLoaded(
          transactions: transactions,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      ),
    );
  }
}
