sealed class AccountEvent {}

class LoadAccount extends AccountEvent {
  final int id;

  LoadAccount(this.id);
}

class ChangeAccountName extends AccountEvent {
  final String newName;

  ChangeAccountName(this.newName);
}

class ChangeCurrency extends AccountEvent {
  final String currency;

  ChangeCurrency(this.currency);
}
