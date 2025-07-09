import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/utils/date_utils.dart';

class TransactionsAnalysisScreen extends StatelessWidget {
  const TransactionsAnalysisScreen({super.key});

  Color _generateColorFromId(int id) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];
    return colors[id % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Анализ'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (transactionContext, transactionState) {
          return BlocBuilder<AccountBloc, AccountBlocState>(
            builder: (accountContext, accountState) {
              return BlocBuilder<CategoryBloc, CategoryState>(
                builder: (categoriesContext, categoriesState) {
                  if (transactionState is TransactionHistoryLoading ||
                      accountState is AccountBlocLoading ||
                      categoriesState is CategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (transactionState is TransactionHistoryError) {
                    return Center(
                      child: Text('Ошибка: ${transactionState.message}'),
                    );
                  } else if (accountState is AccountBlocError) {
                    return Center(
                      child: Text('Ошибка: ${accountState.message}'),
                    );
                  } else if (categoriesState is CategoryError) {
                    return Center(
                      child: Text('Ошибка: ${categoriesState.message}'),
                    );
                  } else if (transactionState is TransactionHistoryLoaded &&
                      accountState is AccountBlocLoaded &&
                      categoriesState is CategoryLoaded) {
                    final totalSum = transactionState.transactions.fold<double>(
                      0,
                      (sum, tx) => sum + tx.amount,
                    );

                    final Map<int, double> sumsByCategoryId = {};
                    for (final tx in transactionState.transactions) {
                      sumsByCategoryId[tx.categoryId!] =
                          (sumsByCategoryId[tx.categoryId] ?? 0) + tx.amount;
                    }

                    final sortedEntries = sumsByCategoryId.entries.toList()
                      ..sort((a, b) => a.value.compareTo(b.value));

                    final sections = sortedEntries.map((entry) {
                      final category = categoriesState.categories.firstWhere(
                        (c) => c.id == entry.key,
                      );
                      final value = entry.value;
                      final percent = totalSum > 0 ? value / totalSum : 0.0;

                      return PieChartSectionData(
                        color: _generateColorFromId(entry.key),
                        value: percent,
                        title: '${(percent * 100).toStringAsFixed(1)}%',
                        radius: 50,
                        titleStyle: Theme.of(
                          transactionContext,
                        ).textTheme.bodySmall,
                        badgeWidget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              transactionContext,
                            ).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '${category.emoji} ${category.name}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        badgePositionPercentageOffset: 1.2,
                      );
                    }).toList();

                    return RefreshIndicator(
                      onRefresh: () async {
                        transactionContext.read<TransactionHistoryBloc>().add(
                          LoadTransactionHistory(
                            startDate: transactionState.startDate,
                            endDate: transactionState.endDate,
                            isIncome: transactionState.isIncome,
                          ),
                        );
                      },
                      child: ListView(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Период: начало'),
                                InkWell(
                                  onTap: () async {
                                    final result = await _pickDate(
                                      transactionContext,
                                      isStart: true,
                                      currentStart: transactionState.startDate,
                                      currentEnd: transactionState.endDate,
                                    );
                                    if (!transactionContext.mounted ||
                                        result == null) {
                                      return;
                                    }

                                    final (newStart, newEnd) = result;
                                    transactionContext
                                        .read<TransactionHistoryBloc>()
                                        .add(
                                          LoadTransactionHistory(
                                            startDate: newStart,
                                            endDate: newEnd,
                                            isIncome: transactionState.isIncome,
                                          ),
                                        );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        transactionContext,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      formatDate(transactionState.startDate),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(transactionContext).dividerColor,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Период: конец'),
                                InkWell(
                                  onTap: () async {
                                    final result = await _pickDate(
                                      transactionContext,
                                      isStart: false,
                                      currentStart: transactionState.startDate,
                                      currentEnd: transactionState.endDate,
                                    );
                                    if (!transactionContext.mounted ||
                                        result == null) {
                                      return;
                                    }

                                    final (newStart, newEnd) = result;
                                    transactionContext
                                        .read<TransactionHistoryBloc>()
                                        .add(
                                          LoadTransactionHistory(
                                            startDate: newStart,
                                            endDate: newEnd,
                                            isIncome: transactionState.isIncome,
                                          ),
                                        );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        transactionContext,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      formatDate(transactionState.endDate),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(transactionContext).dividerColor,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Сумма'),
                                Text(
                                  '$totalSum ${accountState.account.moneyDetails.currency}',
                                  style: Theme.of(
                                    transactionContext,
                                  ).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(transactionContext).dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: AspectRatio(
                              aspectRatio: 1.4,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                  sections: sections,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(transactionContext).dividerColor,
                          ),
                          if (categoriesState.categories.isEmpty)
                            const Center(child: CircularProgressIndicator())
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: sortedEntries.length,
                              itemBuilder: (context, index) {
                                final entry = sortedEntries[index];

                                final categoryId = entry.key;
                                final totalAmount = entry.value;

                                final category = categoriesState.categories
                                    .firstWhere((c) => c.id == categoryId);

                                final percent = totalSum > 0
                                    ? (totalAmount / totalSum * 100)
                                    : 0;

                                final categoryTransactions =
                                    transactionState.transactions
                                        .where(
                                          (tx) => tx.categoryId == categoryId,
                                        )
                                        .toList()
                                      ..sort(
                                        (a, b) =>
                                            b.timestamp.compareTo(a.timestamp),
                                      );

                                final lastTransaction =
                                    categoryTransactions.isNotEmpty
                                    ? categoryTransactions.first
                                    : null;

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    title: Text(category.name),
                                    subtitle: lastTransaction != null
                                        ? Text(
                                            lastTransaction.comment ?? '',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          )
                                        : null,
                                    leading: CircleAvatar(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      radius: 16,
                                      child: Text(
                                        category.emoji,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${percent.toStringAsFixed(1)}%',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                            Text(
                                              '${entry.value.toStringAsFixed(2)} ${accountState.account.moneyDetails.currency}',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 24),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 16,
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _showTransactionsModal(
                                        context,
                                        category,
                                        categoryTransactions,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('Неизвестное состояние'));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showTransactionsModal(
    BuildContext context,
    Category category,
    List<Transaction> transactions,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Транзакции: ${category.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: transactions.isEmpty
                        ? const Center(child: Text('Нет транзакций'))
                        : ListView.separated(
                            controller: scrollController,
                            itemCount: transactions.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final tx = transactions[index];
                              return ListTile(
                                title: Text(tx.comment ?? 'Без описания'),
                                subtitle: Text(
                                  formatDate(tx.timestamp),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: Text(
                                  '${tx.amount.toStringAsFixed(2)} ₽',
                                  style: TextStyle(
                                    color: tx.amount > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
