import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final GetTransactionsByPeriodUseCase getTransactions;

  TransactionHistoryBloc({
    required this.getTransactions,
    required DateTime initialStartDate,
    required DateTime initialEndDate,
    required bool? initialIsIncome,
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
          _createTransaction(event, emit);
          break;
        case ChangeTransactionFilter():
          _onChangeFilter(event, emit);
          break;
        case ChangeTransactionPeriod():
          _onChangePeriod(event, emit);
          break;
        case UpdateTransaction():
          _updateTransaction(event, emit);
          break;
        case DeleteTransaction():
          _deleteTransaction(event, emit);
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

  void _deleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionHistoryState> emit,
  ) {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;
    final updatedList = currentState.transactions
        .where((transaction) => transaction.id != event.transaction.id)
        .toList();

    emit(
      TransactionHistoryLoaded(
        transactions: updatedList,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
        isIncome: currentState.isIncome,
      ),
    );
  }

  void _updateTransaction(
    UpdateTransaction event,
    Emitter<TransactionHistoryState> emit,
  ) {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;
    final updatedList = currentState.transactions.map((transaction) {
      return transaction.id == event.transaction.id
          ? event.transaction
          : transaction;
    }).toList();

    emit(
      TransactionHistoryLoaded(
        transactions: updatedList,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
        isIncome: currentState.isIncome,
      ),
    );
  }

  Future<void> _createTransaction(
    AddSingleTransaction event,
    Emitter<TransactionHistoryState> emit,
  ) async {
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
