import 'package:flutter_finances/domain/entities/value_objects/money_details.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

class Account {
  final int id;
  final int userId;
  final String name;
  final MoneyDetails moneyDetails;
  final AuditInfoTime auditInfoTime;

  Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.moneyDetails,
    required this.auditInfoTime,
  });
}
