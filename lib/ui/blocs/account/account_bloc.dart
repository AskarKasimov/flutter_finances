import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';
import 'package:flutter_finances/ui/blocs/account/account_event.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountBlocState> {
  final AccountRepository repository;

  AccountBloc(this.repository) : super(AccountBlocInitial()) {
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

    add(LoadAccount(1)); // загрузка дефолтного аккаунта
  }

  Future<void> _onLoadAccount(
    LoadAccount event,
    Emitter<AccountBlocState> emit,
  ) async {
    emit(AccountBlocLoading());
    try {
      final account = await repository.getAccountById(event.id);
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
      final updatedAccount = await repository.updateAccount(
        current.id,
        updatedForm,
      );
      emit(
        AccountBlocLoaded(
          AccountState(
            id: current.id,
            name: updatedAccount.name ?? current.name,
            moneyDetails: updatedAccount.moneyDetails ?? current.moneyDetails,
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
      final updatedAccount = await repository.updateAccount(
        current.id,
        updatedForm,
      );
      emit(
        AccountBlocLoaded(
          AccountState(
            id: current.id,
            name: updatedAccount.name ?? current.name,
            moneyDetails: updatedAccount.moneyDetails ?? current.moneyDetails,
          ),
        ),
      );
    } catch (e) {
      emit(AccountBlocError(e.toString()));
    }
  }
}
