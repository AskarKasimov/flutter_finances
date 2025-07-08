import 'package:flutter_finances/domain/entities/account_state.dart';

sealed class AccountBlocState {}

class AccountBlocInitial extends AccountBlocState {}

class AccountBlocLoading extends AccountBlocState {}

class AccountBlocLoaded extends AccountBlocState {
  final AccountState account;

  AccountBlocLoaded(this.account);
}

class AccountBlocError extends AccountBlocState {
  final String message;

  AccountBlocError(this.message);
}
