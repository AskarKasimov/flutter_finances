import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/forms/transaction_form.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';

class TransactionCreationBloc
    extends Bloc<TransactionCreationEvent, TransactionCreationState> {
  final TransactionRepository transactionRepository;

  TransactionCreationBloc(this.transactionRepository)
    : super(TransactionCreationState.initial()) {
    on<TransactionCreationEvent>((event, emit) async {
      switch (event) {
        case TransactionAccountChanged e:
          emit(state.copyWith(accountState: e.account));
          break;
        case TransactionCategoryChanged e:
          emit(state.copyWith(category: e.category));
          break;
        case TransactionAmountChanged e:
          emit(state.copyWith(amount: e.amount));
          break;
        case TransactionDateChanged e:
          emit(state.copyWith(date: e.date));
          break;
        case TransactionCommentChanged e:
          emit(state.copyWith(comment: e.comment));
          break;
        case TransactionFormReset _:
          emit(TransactionCreationState.initial());
          break;
        case TransactionSubmitted e:
          await _onTransactionSubmitted(e, emit);
          break;
      }
    });
  }

  Future<void> _onTransactionSubmitted(
    TransactionSubmitted event,
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
