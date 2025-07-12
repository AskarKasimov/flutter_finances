import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';

class AccountResponse {
  final int id;
  final String name;
  final MoneyDetails moneyDetails;

  AccountResponse({
    required this.id,
    required this.name,
    required this.moneyDetails,
  });
}
