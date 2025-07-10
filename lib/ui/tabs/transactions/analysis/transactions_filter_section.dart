import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/utils/date_utils.dart';

class TransactionsFilterSection extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final bool? isIncome;

  const TransactionsFilterSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateSelector(
          title: 'Период: начало',
          date: startDate,
          isStart: true,
          start: startDate,
          end: endDate,
          isIncome: isIncome,
        ),
        Divider(height: 1, color: Theme.of(context).dividerColor),
        DateSelector(
          title: 'Период: конец',
          date: endDate,
          isStart: false,
          start: startDate,
          end: endDate,
          isIncome: isIncome,
        ),
      ],
    );
  }
}

class DateSelector extends StatelessWidget {
  final String title;
  final DateTime date;
  final bool isStart;
  final DateTime start;
  final DateTime end;
  final bool? isIncome;

  const DateSelector({
    super.key,
    required this.title,
    required this.date,
    required this.isStart,
    required this.start,
    required this.end,
    this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          InkWell(
            onTap: () async {
              final result = await _pickDate(
                context,
                isStart: isStart,
                currentStart: start,
                currentEnd: end,
              );
              if (!context.mounted || result == null) return;

              final (newStart, newEnd) = result;
              context.read<TransactionHistoryBloc>().add(
                LoadTransactionHistory(
                  startDate: newStart,
                  endDate: newEnd,
                  isIncome: isIncome,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(formatDate(date)),
            ),
          ),
        ],
      ),
    );
  }

  Future<(DateTime, DateTime)?> _pickDate(
    BuildContext context, {
    required bool isStart,
    required DateTime currentStart,
    required DateTime currentEnd,
  }) async {
    final initialDate = isStart ? currentStart : currentEnd;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return null;

    DateTime newStart = currentStart;
    DateTime newEnd = currentEnd;

    if (isStart) {
      newStart = DateTime(date.year, date.month, date.day);
      if (newStart.isAfter(newEnd)) {
        newEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
      }
    } else {
      newEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
      if (newEnd.isBefore(newStart)) {
        newStart = DateTime(date.year, date.month, date.day);
      }
    }

    return (newStart, newEnd);
  }
}
