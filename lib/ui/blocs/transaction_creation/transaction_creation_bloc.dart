import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';

class TransactionCreationBloc
    extends Bloc<TransactionCreationEvent, TransactionCreationState> {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;
  final AccountRepository accountRepository;

  TransactionCreationBloc(
    this.transactionRepository,
    this.categoryRepository,
    this.accountRepository,
  ) : super(TransactionDataState.initial()) {
    on<TransactionCreationEvent>((event, emit) async {
      final currentState = state;
      if (currentState is! TransactionDataState) return;

      switch (event) {
        case TransactionAccountChanged():
          emit(currentState.copyWith(accountState: event.account));
          break;

        case TransactionCategoryChanged():
          emit(currentState.copyWith(category: event.category));
          break;

        case TransactionAmountChanged():
          emit(currentState.copyWith(amount: event.amount));
          break;

        case TransactionDateChanged():
          emit(currentState.copyWith(date: event.date));
          break;

        case TransactionCommentChanged():
          emit(currentState.copyWith(comment: event.comment));
          break;

        case TransactionFormReset():
          emit(TransactionDataState.initial());
          break;

        case CreateTransactionSubmitted():
          await _onTransactionSubmitted(event, emit, currentState);
          break;

        case InitializeForEditing():
          await _initForEditing(event, emit);
          break;

        case UpdateTransactionSubmitted():
          await _onTransactionUpdated(event, emit, currentState);
          break;

        case DeleteTransactionSubmitted():
          await _onTransactionDeleted(event, emit);
          break;
      }
    });
  }

  Future<void> _onTransactionDeleted(
    DeleteTransactionSubmitted event,
    Emitter<TransactionCreationState> emit,
  ) async {
    try {
      if (state is! TransactionDataState) return;
      final data = state as TransactionDataState;

      emit(TransactionProcessing());
      final deletedTransaction = await transactionRepository.getTransactionById(
        event.transactionId,
      );
      await transactionRepository.deleteTransaction(event.transactionId);
      emit(TransactionDeletedSuccessfully(deletedTransaction, data));
    } catch (e) {
      // Обработка ошибок
    }
  }

  Future<void> _onTransactionUpdated(
    UpdateTransactionSubmitted event,
    Emitter<TransactionCreationState> emit,
    TransactionDataState currentState,
  ) async {
    if (!currentState.isValid) {
      return;
    }

    try {
      emit(TransactionProcessing());
      final transaction = await transactionRepository.updateTransaction(
        event.transactionId,
        TransactionForm(
          accountId: currentState.accountState!.id,
          categoryId: currentState.category!.id,
          amount: currentState.amount,
          timestamp: currentState.date,
          comment: currentState.comment,
        ),
      );

      emit(TransactionUpdatedSuccessfully(transaction, currentState));
    } catch (e) {
      // Обработка ошибок
    }
  }

  Future<void> _initForEditing(
    InitializeForEditing event,
    Emitter<TransactionCreationState> emit,
  ) async {
    emit(TransactionProcessing());
    final transaction = await transactionRepository.getTransactionById(
      event.transactionId,
    );
    final categories = await categoryRepository.getAllCategories();
    final category = categories.firstWhere(
      (c) => c.id == transaction.categoryId,
    );
    final accounts = await accountRepository.getAllAccounts();
    final account = accounts.firstWhere((a) => a.id == transaction.accountId);
    emit(
      TransactionDataState(
        amount: transaction.amount,
        category: category,
        accountState: AccountState(
          id: account.id,
          name: account.name,
          moneyDetails: account.moneyDetails,
        ),
        comment: transaction.comment ?? '',
        date: transaction.timestamp,
      ),
    );
  }

  Future<void> _onTransactionSubmitted(
    CreateTransactionSubmitted event,
    Emitter<TransactionCreationState> emit,
    TransactionDataState currentState,
  ) async {
    if (!currentState.isValid) {
      return;
    }

    try {
      emit(TransactionProcessing());
      final transaction = await transactionRepository.createTransaction(
        TransactionForm(
          accountId: currentState.accountState!.id,
          categoryId: currentState.category!.id,
          amount: currentState.amount,
          timestamp: currentState.date,
          comment: currentState.comment,
        ),
      );

      emit(TransactionCreatedSuccessfully(transaction, currentState));
    } catch (e) {
      // Обработка ошибок
    }
  }
}
