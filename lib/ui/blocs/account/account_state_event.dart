sealed class AccountEvent {}

class ChangeCurrency extends AccountEvent {
  final String currency;

  ChangeCurrency(this.currency);
}

class ChangeAccountName extends AccountEvent {
  final String newName;

  ChangeAccountName(this.newName);
}

class LoadAccount extends AccountEvent {
  final int id;
  LoadAccount(this.id);
}
