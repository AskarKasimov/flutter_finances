import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/enums/change_type.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

class AccountHistoryItem {
  final int id;
  final int accountId;
  final ChangeType changeType;
  final AccountState? previousState;
  final AccountState newState;
  final AuditInfoTime auditInfoTime;

  AccountHistoryItem({
    required this.id,
    required this.accountId,
    required this.changeType,
    required this.previousState,
    required this.newState,
    required this.auditInfoTime,
  });
}
