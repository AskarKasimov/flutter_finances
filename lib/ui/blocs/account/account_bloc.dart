import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/forms/account_form.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/blocs/account/account_event.dart';

class AccountBloc extends Bloc<AccountEvent, AccountBlocState> {
  final AccountRepository repository;

  AccountBloc(this.repository) : super(AccountBlocState(isLoading: true)) {
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
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final account = await repository.getAccountById(event.id);
      emit(
        state.copyWith(
          isLoading: false,
          account: AccountState(
            id: account.id,
            name: account.name,
            moneyDetails: account.moneyDetails,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeAccountName(
    ChangeAccountName event,
    Emitter<AccountBlocState> emit,
  ) async {
    if (state.account == null) return;
    try {
      final updatedForm = AccountForm(
        name: event.newName,
        moneyDetails: state.account!.moneyDetails,
      );
      final updatedAccount = await repository.updateAccount(
        state.account!.id,
        updatedForm,
      );
      emit(
        state.copyWith(
          account: AccountState(
            id: state.account!.id,
            name: updatedAccount.name ?? state.account!.name,
            moneyDetails:
                updatedAccount.moneyDetails ?? state.account!.moneyDetails,
          ),
        ),
      );
    } catch (e) {
      // обработка ошибки, если надо
    }
  }

  Future<void> _onChangeCurrency(
    ChangeCurrency event,
    Emitter<AccountBlocState> emit,
  ) async {
    if (state.account == null) return;
    try {
      final updatedForm = AccountForm(
        name: state.account!.name,
        moneyDetails: state.account!.moneyDetails.copyWith(
          currency: event.currency,
        ),
      );
      final updatedAccount = await repository.updateAccount(
        state.account!.id,
        updatedForm,
      );
      emit(
        state.copyWith(
          account: AccountState(
            id: state.account!.id,
            name: updatedAccount.name ?? state.account!.name,
            moneyDetails:
                updatedAccount.moneyDetails ?? state.account!.moneyDetails,
          ),
        ),
      );
    } catch (e) {
      // обработка ошибки
    }
  }
}
