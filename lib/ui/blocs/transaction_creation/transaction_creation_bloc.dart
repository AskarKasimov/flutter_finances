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
  ) : super(TransactionCreationState.initial()) {
    on<TransactionCreationEvent>((event, emit) async {
      switch (event) {
        case TransactionAccountChanged():
          emit(state.copyWith(accountState: event.account));
          break;
        case TransactionCategoryChanged():
          emit(state.copyWith(category: event.category));
          break;
        case TransactionAmountChanged():
          emit(state.copyWith(amount: event.amount));
          break;
        case TransactionDateChanged():
          emit(state.copyWith(date: event.date));
          break;
        case TransactionCommentChanged():
          emit(state.copyWith(comment: event.comment));
          break;
        case TransactionFormReset():
          emit(TransactionCreationState.initial());
          break;
        case CreateTransactionSubmitted():
          await _onTransactionSubmitted(event, emit);
          break;
        case InitializeForEditing():
          await _initForEditing(event, emit);
          break;
        case UpdateTransactionSubmitted():
          await _onTransactionUpdated(event, emit);
          break;
      }
    });
  }

  Future<void> _onTransactionUpdated(
    UpdateTransactionSubmitted event,
    Emitter<TransactionCreationState> emit,
  ) async {
    final currentState = state;

    if (!currentState.isValid) {
      return;
    }

    try {
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

      emit(TransactionSubmittedSuccessfully(transaction, currentState));
    } catch (e) {}
  }

  Future<void> _initForEditing(
    InitializeForEditing event,
    Emitter<TransactionCreationState> emit,
  ) async {
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
      state.copyWith(
        amount: transaction.amount,
        category: category,
        accountState: AccountState(
          id: account.id,
          name: account.name,
          moneyDetails: account.moneyDetails,
        ),
        comment: transaction.comment,
        date: transaction.timestamp,
      ),
    );
  }

  Future<void> _onTransactionSubmitted(
    CreateTransactionSubmitted event,
    Emitter<TransactionCreationState> emit,
  ) async {
    final currentState = state;

    if (!currentState.isValid) {
      return;
    }

    try {
      final transaction = await transactionRepository.createTransaction(
        TransactionForm(
          accountId: 1,
          categoryId: state.category!.id,
          amount: state.amount,
          timestamp: state.date,
          comment: state.comment,
        ),
      );

      emit(TransactionSubmittedSuccessfully(transaction, currentState));
    } catch (e) {}
  }
}
