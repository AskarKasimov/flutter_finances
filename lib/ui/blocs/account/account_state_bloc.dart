import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/ui/blocs/account/account_state_event.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc()
    : super(
        AccountState(
          id: 1,
          name: 'Основной счёт',
          moneyDetails: MoneyDetails(balance: 670000, currency: '₽'),
        ),
      ) {
    on<ChangeCurrency>((event, emit) {
      emit(
        state.copyWith(
          moneyDetails: state.moneyDetails.copyWith(currency: event.currency),
        ),
      );
    });
  }
}
