import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';
import 'package:flutter_finances/ui/blocs/account/account_state_event.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  AccountBloc(this.repository)
    : super(
        AccountState(
          id: 0,
          name: '',
          moneyDetails: MoneyDetails(balance: 0, currency: ''),
        ),
      ) {
    on<AccountEvent>((event, emit) async {
      switch (event) {
        case LoadAccount loadAccount:
          await _onLoadAccount(loadAccount, emit);
          break;
        case ChangeAccountName changeAccountName:
          await _onChangeAccountName(changeAccountName, emit);
          break;
        case ChangeCurrency changeCurrency:
          await _onChangeCurrency(changeCurrency, emit);
          break;
      }
    });
    add(LoadAccount(1));
  }

  Future<void> _onLoadAccount(
    LoadAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final response = await repository.getAccountById(event.id);
      emit(
        AccountState(
          id: response.id,
          name: response.name,
          moneyDetails: response.moneyDetails,
        ),
      );
    } catch (e) {}
  }

  Future<void> _onChangeAccountName(
    ChangeAccountName event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final updatedForm = AccountForm(
        name: event.newName,
        moneyDetails: state.moneyDetails,
      );
      final updatedAccountForm = await repository.updateAccount(
        state.id,
        updatedForm,
      );

      emit(state.copyWith(name: updatedAccountForm.name ?? state.name));
    } catch (e) {}
  }

  Future<void> _onChangeCurrency(
    ChangeCurrency event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final updatedForm = AccountForm(
        name: state.name,
        moneyDetails: state.moneyDetails.copyWith(currency: event.currency),
      );
      final updatedAccountForm = await repository.updateAccount(
        state.id,
        updatedForm,
      );
      emit(
        state.copyWith(
          moneyDetails: state.moneyDetails.copyWith(
            currency:
                updatedAccountForm.moneyDetails?.currency ??
                state.moneyDetails.currency,
          ),
        ),
      );
    } catch (e) {}
  }
}
