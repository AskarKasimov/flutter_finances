import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/usecases/get_account_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_account_usecase.dart';
import 'package:flutter_finances/ui/blocs/account/account_event.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountBlocState> {
  final GetAccountByIdUseCase getAccountByIdUseCase;
  final UpdateAccountUseCase updateAccountUseCase;

  AccountBloc({
    required this.getAccountByIdUseCase,
    required this.updateAccountUseCase,
  }) : super(AccountBlocLoading()) {
    on<AccountEvent>((event, emit) async {
      switch (event) {
        case LoadAccount():
          await _onLoadAccount(event, emit);
          break;
        case ChangeAccountName():
          await _onChangeAccountName(event, emit);
          break;
        case ChangeCurrency():
          await _onChangeCurrency(event, emit);
          break;
      }
    });
  }

  Future<void> _onLoadAccount(
    LoadAccount event,
    Emitter<AccountBlocState> emit,
  ) async {
    emit(AccountBlocLoading());
    try {
      final account = await getAccountByIdUseCase(event.id);
      emit(
        AccountBlocLoaded(
          AccountState(
            id: account.id,
            name: account.name,
            moneyDetails: account.moneyDetails,
          ),
        ),
      );
    } catch (e) {
      emit(AccountBlocError(e.toString()));
    }
  }

  Future<void> _onChangeAccountName(
    ChangeAccountName event,
    Emitter<AccountBlocState> emit,
  ) async {
    if (state is! AccountBlocLoaded) return;
    final current = (state as AccountBlocLoaded).account;
    try {
      final updatedForm = AccountForm(
        name: event.newName,
        moneyDetails: current.moneyDetails,
      );
      final updatedAccount = await updateAccountUseCase(
        current.id,
        updatedForm,
      );
      emit(
        AccountBlocLoaded(
          AccountState(
            id: current.id,
            name: updatedAccount.name,
            moneyDetails: updatedAccount.moneyDetails,
          ),
        ),
      );
    } catch (e) {
      emit(AccountBlocError(e.toString()));
    }
  }

  Future<void> _onChangeCurrency(
    ChangeCurrency event,
    Emitter<AccountBlocState> emit,
  ) async {
    if (state is! AccountBlocLoaded) return;
    final current = (state as AccountBlocLoaded).account;
    try {
      final updatedForm = AccountForm(
        name: current.name,
        moneyDetails: current.moneyDetails.copyWith(currency: event.currency),
      );
      final updatedAccount = await updateAccountUseCase(
        current.id,
        updatedForm,
      );
      emit(
        AccountBlocLoaded(
          AccountState(
            id: current.id,
            name: updatedAccount.name,
            moneyDetails: updatedAccount.moneyDetails,
          ),
        ),
      );
    } catch (e) {
      emit(AccountBlocError(e.toString()));
    }
  }
}
