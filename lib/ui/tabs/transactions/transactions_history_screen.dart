import 'package:flutter/material.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_list.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_screen.dart';

class TransactionsHistoryScreen extends StatefulWidget {
  final TransactionType type;

  const TransactionsHistoryScreen({super.key, required this.type});

  @override
  State<TransactionsHistoryScreen> createState() =>
      _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState extends State<TransactionsHistoryScreen> {
  late Future<List<Transaction>> _futureExpenses;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month - 1, now.day);
    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _futureExpenses = _loadTransactions();
  }

  Future<List<Transaction>> _loadTransactions() async {
    final result = await MockedTransactionRepository().getTransactionsByPeriod(
      1,
      _startDate,
      _endDate,
    );

    return result.fold(
      (failure) => [],
      (transactions) =>
          transactions
              .where(
                (tx) =>
                    tx.category?.isIncome ==
                    (widget.type == TransactionType.income),
              )
              .toList(),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _futureExpenses = _loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: _futureExpenses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data ?? [];
        return Scaffold(
          appBar: AppBar(
            title: Text('Моя история'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.analytics_outlined),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: Column(
              children: [
                InkWell(
                  onTap: () => _pickDate(isStart: true),
                  child: Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Начало'),
                        Text(
                          _formatDate(_startDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _pickDate(isStart: false),
                  child: Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Конец'),
                        Text(
                          _formatDate(_endDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TransactionsList(
                    transactions: transactions,
                    showTime: true,
                    onTapTransaction: (transaction) {
                      // TODO: route to transaction screen
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final current = isStart ? _startDate : _endDate;

    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      if (isStart) {
        _startDate = DateTime(date.year, date.month, date.day);
        if (_startDate.isAfter(_endDate)) {
          _endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
        }
      } else {
        _endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
        if (_endDate.isBefore(_startDate)) {
          _startDate = DateTime(date.year, date.month, date.day);
        }
      }

      _refresh();
    });
  }
}
