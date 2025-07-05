import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final UseCaseGetTransactionsByPeriod getTransactions;
  final TransactionRepository transactionRepository;

  TransactionHistoryBloc({
    required this.getTransactions,
    required this.transactionRepository,
    required DateTime initialStartDate,
    required DateTime initialEndDate,
    required bool initialIsIncome,
  }) : super(
         TransactionHistoryLoading(
           startDate: initialStartDate,
           endDate: initialEndDate,
           isIncome: initialIsIncome,
         ),
       ) {
    on<TransactionHistoryEvent>((event, emit) async {
      switch (event) {
        case LoadTransactionHistory():
          await _onLoadTransactions(event, emit);
          break;
        case AddSingleTransaction():
          final currentState = state as TransactionHistoryLoaded;
          final updatedList = List<Transaction>.from(currentState.transactions)
            ..insert(0, event.transaction);

          emit(
            TransactionHistoryLoaded(
              transactions: updatedList,
              startDate: currentState.startDate,
              endDate: currentState.endDate,
              isIncome: currentState.isIncome,
            ),
          );
          break;
        case ChangeTransactionFilter():
          _onChangeFilter(event, emit);
          break;
        case ChangeTransactionPeriod():
          _onChangePeriod(event, emit);
          break;
      }
    });
    // загрузка при инициализации
    add(
      LoadTransactionHistory(
        startDate: initialStartDate,
        endDate: initialEndDate,
        isIncome: initialIsIncome,
      ),
    );
  }

  Future<void> _onLoadTransactions(
    LoadTransactionHistory event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(
      TransactionHistoryLoading(
        startDate: event.startDate,
        endDate: event.endDate,
        isIncome: event.isIncome,
      ),
    );

    try {
      final transactions = await getTransactions(
        startDate: event.startDate,
        endDate: event.endDate,
        isIncome: event.isIncome,
      );
      emit(
        TransactionHistoryLoaded(
          transactions: transactions,
          startDate: event.startDate,
          endDate: event.endDate,
          isIncome: event.isIncome,
        ),
      );
    } catch (e) {
      emit(
        TransactionHistoryError(
          message: e.toString(),
          startDate: event.startDate,
          endDate: event.endDate,
          isIncome: event.isIncome,
        ),
      );
    }
  }

  void _onChangeFilter(
    ChangeTransactionFilter event,
    Emitter<TransactionHistoryState> emit,
  ) {
    // меняем фильтр, загружаем заново с текущим периодом
    add(
      LoadTransactionHistory(
        startDate: state.startDate,
        endDate: state.endDate,
        isIncome: event.isIncome,
      ),
    );
  }

  void _onChangePeriod(
    ChangeTransactionPeriod event,
    Emitter<TransactionHistoryState> emit,
  ) {
    // меняем период, загружаем заново с текущим фильтром
    add(
      LoadTransactionHistory(
        startDate: event.startDate,
        endDate: event.endDate,
        isIncome: state.isIncome,
      ),
    );
  }
}
