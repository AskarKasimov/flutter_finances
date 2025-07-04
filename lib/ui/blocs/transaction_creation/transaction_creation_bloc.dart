import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_state.dart';

class TransactionCreationBloc
    extends Bloc<TransactionCreationEvent, TransactionCreationState> {
  TransactionCreationBloc() : super(TransactionCreationState.initial()) {
    on<TransactionAmountChanged>(
      (e, emit) => emit(state.copyWith(amount: e.amount)),
    );
    on<TransactionCommentChanged>(
      (e, emit) => emit(state.copyWith(comment: e.comment)),
    );
    on<TransactionDateChanged>((e, emit) => emit(state.copyWith(date: e.date)));
    on<TransactionAccountChanged>(
      (e, emit) => emit(state.copyWith(account: e.account)),
    );
    on<TransactionCategoryChanged>(
      (e, emit) => emit(state.copyWith(category: e.category)),
    );
    on<TransactionFormReset>(
      (e, emit) => emit(TransactionCreationState.initial()),
    );
    on<TransactionSubmitted>((e, emit) {
      // TODO: handle submission logic, i.e. call repository
    });
  }
}
