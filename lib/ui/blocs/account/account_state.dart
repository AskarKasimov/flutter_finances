import 'package:flutter_finances/domain/entities/account_state.dart';

class AccountBlocState {
  final bool isLoading;
  final AccountState? account;
  final String? errorMessage;

  AccountBlocState({this.isLoading = false, this.account, this.errorMessage});

  AccountBlocState copyWith({
    bool? isLoading,
    AccountState? account,
    String? errorMessage,
  }) {
    return AccountBlocState(
      isLoading: isLoading ?? this.isLoading,
      account: account ?? this.account,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
