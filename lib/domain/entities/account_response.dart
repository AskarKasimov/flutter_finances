import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

class AccountResponse {
  final int id;
  final String name;
  final MoneyDetails moneyDetails;
  final AuditInfoTime auditInfoTime;

  AccountResponse({
    required this.id,
    required this.name,
    required this.moneyDetails,
    required this.auditInfoTime,
  });
}
