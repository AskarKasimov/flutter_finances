import 'package:dartz/dartz.dart';
import 'package:flutter_finances/data/mappers/account_state_mapper.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_changetype.dart';
import 'package:flutter_finances/data/mappers/types/try_parse_datetime.dart';
import 'package:flutter_finances/data/models/account_history/account_history.dart';
import 'package:flutter_finances/domain/entities/account_history_item.dart';
import 'package:flutter_finances/domain/entities/account_state.dart';
import 'package:flutter_finances/domain/entities/value_objects/time_interval.dart';
import 'package:flutter_finances/domain/failures/failure.dart';

extension AccountHistoryItemMapper on AccountHistoryDTO {
  Either<Failure, AccountHistoryItem> toDomain() {
    final createdAtOrFailure = tryParseDateTime(createdAt, 'createdAt');
    final updatedAtOrFailure = tryParseDateTime(
      changeTimestamp,
      'changeTimestamp',
    );
    final typeParsedOrFailure = tryParseChangeType(changeType, 'changeType');
    final Either<Failure, AccountState?> previousStateOrFailure =
        previousState != null ? previousState!.toDomain() : right(null);
    final newStateOrFailure = newState.toDomain();

    return createdAtOrFailure.flatMap(
      (parsedCreatedAt) => updatedAtOrFailure.flatMap(
        (parsedUpdatedAt) => typeParsedOrFailure.flatMap(
          (parsedChangeType) => previousStateOrFailure.flatMap(
            (parsedPreviousState) => newStateOrFailure.map(
              (parsedNewState) => AccountHistoryItem(
                id: this.id,
                accountId: accountId,
                changeType: parsedChangeType,
                previousState: parsedPreviousState,
                newState: parsedNewState,
                timeInterval: AuditInfoTime(
                  createdAt: parsedCreatedAt,
                  updatedAt: parsedUpdatedAt,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
