import 'package:flutter_finances/data/mappers/account_state_mapper.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_changetype.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/models/account_history/account_history.dart';
import 'package:flutter_finances/domain/entities/account_history_item.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';

extension AccountHistoryItemMapper on AccountHistoryDTO {
  AccountHistoryItem toDomain() {
    final parsedCreatedAt = tryParseDateTime(createdAt, 'createdAt');
    final parsedUpdatedAt = tryParseDateTime(
      changeTimestamp,
      'changeTimestamp',
    );
    final parsedChangeType = tryParseChangeType(changeType, 'changeType');

    final AccountState? parsedPreviousState = previousState?.toDomain();

    final parsedNewState = newState.toDomain();

    return AccountHistoryItem(
      id: id,
      accountId: accountId,
      changeType: parsedChangeType,
      previousState: parsedPreviousState,
      newState: parsedNewState,
      auditInfoTime: AuditInfoTime(
        createdAt: parsedCreatedAt,
        updatedAt: parsedUpdatedAt,
      ),
    );
  }
}
