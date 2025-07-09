import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/usecases/create_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/delete_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_accounts_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_categories_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transaction_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_transaction_usecase.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';

class TransactionCreationBloc
    extends Bloc<TransactionCreationEvent, TransactionCreationState> {
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final GetAllAccountsUseCase getAllAccountsUseCase;
  final GetTransactionByIdUseCase getTransactionByIdUseCase;
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final CreateTransactionUseCase createTransactionUseCase;

  TransactionCreationBloc({
    required this.deleteTransactionUseCase,
    required this.getAllAccountsUseCase,
    required this.getTransactionByIdUseCase,
    required this.getAllCategoriesUseCase,
    required this.updateTransactionUseCase,
    required this.createTransactionUseCase,
  }) : super(TransactionDataState.initial()) {
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
      final deletedTransaction = await deleteTransactionUseCase(
        event.transactionId,
      );
      emit(TransactionDeletedSuccessfully(deletedTransaction, data));
    } catch (e) {
      emit(TransactionError(message: e.toString()));
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
      final transaction = await updateTransactionUseCase(
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
      emit(TransactionError(message: e.toString()));
    }
  }

  Future<void> _initForEditing(
    InitializeForEditing event,
    Emitter<TransactionCreationState> emit,
  ) async {
    emit(TransactionProcessing());
    final transaction = await getTransactionByIdUseCase(event.transactionId);
    final categories = await getAllCategoriesUseCase();
    final category = categories.firstWhere(
      (c) => c.id == transaction.categoryId,
    );
    final accounts = await getAllAccountsUseCase();
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
      final transaction = await createTransactionUseCase(
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
      emit(TransactionError(message: e.toString()));
    }
  }
}
