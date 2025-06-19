import 'package:flutter/material.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_list.dart';
import 'package:go_router/go_router.dart';

class TransactionsScreen extends StatefulWidget {
  final bool isIncome;

  const TransactionsScreen({super.key, required this.isIncome});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<List<Transaction>> _futureExpenses;

  @override
  void initState() {
    super.initState();
    _futureExpenses = _loadTransactions();
  }

  Future<List<Transaction>> _loadTransactions() async {
    final now = DateTime.now();
    final result = await MockedTransactionRepository().getTransactionsByPeriod(
      1,
      DateTime(now.year, now.month, now.day), // the start of the day
      DateTime(now.year, now.month, now.day + 1), // the end of the day
    );

    return result.fold(
      (failure) => [],
      (transactions) =>
          transactions
              .where((tx) => tx.category?.isIncome == widget.isIncome)
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

        final expenses = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.isIncome ? 'Доходы сегодня' : 'Расходы сегодня'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  context.go(
                    widget.isIncome ? '/income/history' : '/expenses/history',
                  );
                },
                icon: const Icon(Icons.history_outlined),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed:
                () => {
                  // TODO: route to adding transaction screen
                },
            child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child:
                expenses.isEmpty
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.isIncome
                                      ? 'Здесь будут твои доходы'
                                      : 'Здесь будут твои расходы',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Добавь нажатием на плюсик :)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                    : TransactionsList(
                      transactions: expenses,
                      onTapTransaction: (transaction) {
                        // TODO: route to transaction screen
                      },
                    ),
          ),
        );
      },
    );
  }
}
