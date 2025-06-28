import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period.dart';
import 'package:flutter_finances/gen/assets.gen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_list.dart';
import 'package:flutter_finances/utils/date_utils.dart';
import 'package:go_router/go_router.dart';

class TransactionsHistoryScreen extends StatelessWidget {
  final bool isIncome;

  const TransactionsHistoryScreen({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 1, now.day);
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return BlocProvider(
      create:
          (_) => TransactionHistoryBloc(
            getTransactions: UseCaseGetTransactionsByPeriod(
              MockedTransactionRepository(),
              MockedCategoryRepository(),
            ),
            isIncome: isIncome,
            startDate: startDate,
            endDate: endDate,
          ),
      child: _TransactionsHistoryView(isIncome: isIncome),
    );
  }
}

class _TransactionsHistoryView extends StatelessWidget {
  final bool isIncome;

  const _TransactionsHistoryView({required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя история'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.go(isIncome ? '/income/history/analysis' : '/expenses/history/analysis');
            },
            icon: Assets.icons.history.svg(width: 24, height: 24),
          ),
        ],
      ),
      body: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
          if (state is TransactionHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionHistoryError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is TransactionHistoryLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionHistoryBloc>().add(
                  LoadTransactionHistory(
                    startDate: state.startDate,
                    endDate: state.endDate,
                  ),
                );
              },
              child: Column(
                children: [
                  DatePickerRow(start: state.startDate, end: state.endDate),
                  Expanded(
                    child: TransactionsList(
                      transactions: state.transactions,
                      showTime: true,
                      showSortMethods: true,
                      onTapTransaction: (tx) {},
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Неизвестное состояние'));
          }
        },
      ),
    );
  }
}

class DatePickerRow extends StatelessWidget {
  final DateTime start;
  final DateTime end;

  const DatePickerRow({super.key, required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final result = await _pickDate(
              context,
              isStart: true,
              currentStart: start,
              currentEnd: end,
            );
            if (!context.mounted || result == null) return;
            final (startDate, endDate) = result;
            context.read<TransactionHistoryBloc>().add(
              LoadTransactionHistory(startDate: startDate, endDate: endDate),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Начало'), Text(formatDate(start))],
            ),
          ),
        ),
        Divider(height: 1, color: Theme.of(context).dividerColor),
        InkWell(
          onTap: () async {
            final result = await _pickDate(
              context,
              isStart: false,
              currentStart: start,
              currentEnd: end,
            );
            if (!context.mounted || result == null) return;
            final (startDate, endDate) = result;
            context.read<TransactionHistoryBloc>().add(
              LoadTransactionHistory(startDate: startDate, endDate: endDate),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Конец'), Text(formatDate(end))],
            ),
          ),
        ),
      ],
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
