import 'value_objects/money_details.dart';

class AccountState {
  final int id;
  final String name;
  final MoneyDetails moneyDetails;

  AccountState({
    required this.id,
    required this.name,
    required this.moneyDetails,
  });

  AccountState copyWith({int? id, String? name, MoneyDetails? moneyDetails}) {
    return AccountState(
      id: id ?? this.id,
      name: name ?? this.name,
      moneyDetails: moneyDetails ?? this.moneyDetails,
    );
  }
}
