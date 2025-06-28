sealed class AccountEvent {}

class ChangeCurrency extends AccountEvent {
  final String currency;

  ChangeCurrency(this.currency);
}
