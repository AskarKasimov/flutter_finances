import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period.dart';
import 'package:flutter_finances/utils/date_utils.dart';

class TransactionsAnalysisScreen extends StatelessWidget {
  final bool isIncome;

  const TransactionsAnalysisScreen({super.key, required this.isIncome});

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
          )..add(
            LoadTransactionHistory(startDate: startDate, endDate: endDate),
          ),
      child: _TransactionsAnalysisView(),
    );
  }
}

class _TransactionsAnalysisView extends StatefulWidget {
  @override
  State<_TransactionsAnalysisView> createState() =>
      _TransactionsAnalysisViewState();
}

class _TransactionsAnalysisViewState extends State<_TransactionsAnalysisView> {
  List<Category> _categories = [];

  late DateTime start;
  late DateTime end;

  Future<void> _loadCategories() async {
    final categoryRepo = MockedCategoryRepository();
    final cats = await categoryRepo.getAllCategories();
    if (mounted) {
      setState(() {
        _categories = cats;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    start = DateTime(now.year, now.month - 1, now.day);
    end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    _loadCategories();
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
        builder: (context, state) {
          if (state is TransactionHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionHistoryError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is TransactionHistoryLoaded) {
            final totalSum = state.transactions.fold<double>(
              0,
              (sum, tx) => sum + tx.amount,
            );

            final categoryById = {for (var cat in _categories) cat.id: cat};

            final Map<int, double> sumsByCategoryId = {};
            for (final tx in state.transactions) {
              sumsByCategoryId[tx.categoryId!] =
                  (sumsByCategoryId[tx.categoryId] ?? 0) + tx.amount;
            }

            final sortedEntries =
                sumsByCategoryId.entries.toList()
                  ..sort((a, b) => a.value.compareTo(b.value));

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionHistoryBloc>().add(
                  LoadTransactionHistory(startDate: start, endDate: end),
                );
                await _loadCategories();
              },
              child: ListView(
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

                      final (newStart, newEnd) = result;
                      setState(() {
                        start = newStart;
                        end = newEnd;
                      });

                      context.read<TransactionHistoryBloc>().add(
                        LoadTransactionHistory(startDate: start, endDate: end),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Период: начало'),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(formatDate(start)),
                          ),
                        ],
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

                      final (newStart, newEnd) = result;
                      setState(() {
                        start = newStart;
                        end = newEnd;
                      });

                      context.read<TransactionHistoryBloc>().add(
                        LoadTransactionHistory(startDate: start, endDate: end),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Период: конец'),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(formatDate(end)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Theme.of(context).dividerColor),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Сумма'),
                        Text(
                          '$totalSum ₽',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Theme.of(context).dividerColor),
                  if (_categories.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: sortedEntries.length,
                      itemBuilder: (context, index) {
                        final entry = sortedEntries[index];

                        final categoryId = entry.key;
                        final totalAmount = entry.value;

                        final category = _categories.firstWhere(
                          (c) => c.id == categoryId,
                        );

                        final percent =
                            totalSum > 0 ? (totalAmount / totalSum * 100) : 0;

                        final categoryTransactions =
                            state.transactions
                                .where((tx) => tx.categoryId == categoryId)
                                .toList()
                              ..sort(
                                (a, b) => b.timestamp.compareTo(a.timestamp),
                              );

                        final lastTransaction =
                            categoryTransactions.isNotEmpty
                                ? categoryTransactions.first
                                : null;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          title: Text(category.name),
                          subtitle:
                              lastTransaction != null
                                  ? Text(
                                    lastTransaction.comment ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                  : null,
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            radius: 16,
                            child: Text(
                              category.emoji ?? '',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${percent.toStringAsFixed(1)}%',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    entry.value.toStringAsFixed(2),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 16,
                                color: Theme.of(context).iconTheme.color,
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
                        );
                      },
                      separatorBuilder:
                          (BuildContext context, int index) => Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
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
                    child:
                        transactions.isEmpty
                            ? Center(child: Text('Нет транзакций'))
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  trailing: Text(
                                    '${tx.amount.toStringAsFixed(2)} ₽',
                                    style: TextStyle(
                                      color:
                                          tx.amount > 0
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
