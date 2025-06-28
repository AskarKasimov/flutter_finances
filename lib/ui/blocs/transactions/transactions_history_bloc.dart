import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period.dart';

import './transactions_history_event.dart';
import './transactions_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final UseCaseGetTransactionsByPeriod getTransactions;
  final bool isIncome;

  TransactionHistoryBloc({
    required this.getTransactions,
    required this.isIncome,
    required DateTime startDate,
    required DateTime endDate,
  }) : super(
         TransactionHistoryLoading(startDate: startDate, endDate: endDate),
       ) {
    on<TransactionHistoryEvent>((event, emit) async {
      switch (event) {
        case LoadTransactionHistory():
          await _onLoadTransactions(event, emit);
          break;
      }
    });
    add(LoadTransactionHistory(startDate: startDate, endDate: endDate));
  }

  Future<void> _onLoadTransactions(
    LoadTransactionHistory event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    try {
      final transactions = await getTransactions(
        startDate: event.startDate,
        endDate: event.endDate,
        isIncome: isIncome,
      );
      emit(
        TransactionHistoryLoaded(
          transactions: transactions,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    } catch (e) {
      emit(
        TransactionHistoryError(
          message: e.toString(),
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    }
  }
}
