import 'package:flutter/material.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/ui/navigation/tab_screen_interface.dart';

enum TransactionType { income, expense }

class TransactionsScreen extends StatefulWidget implements TabScreen {
  final TransactionType type;

  const TransactionsScreen({super.key, required this.type});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();

  @override
  IconData get tabIcon =>
      type == TransactionType.income
          ? Icons.trending_up_outlined
          : Icons.trending_down_outlined;

  @override
  String get tabLabel => type == TransactionType.income ? 'Доходы' : 'Расходы';

  @override
  AppBar get appBar => AppBar(
    title: Text(
      type == TransactionType.income ? 'Доходы сегодня' : 'Расходы сегодня',
    ),
    centerTitle: true,
  );

  @override
  String get routePath =>
      type == TransactionType.income ? '/incomes' : '/expenses';

  @override
  Widget? get floatingActionButton => FloatingActionButton(
    onPressed: () {
      // TODO: route to add transaction screen
    },
    child: const Icon(Icons.add),
  );
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

        final expenses = snapshot.data ?? [];
        final totalSum = expenses.fold<double>(0, (sum, tx) => sum + tx.amount);

        return RefreshIndicator(
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
                                widget.type == TransactionType.income
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
                  : Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Всего'),
                              Text(
                                '$totalSum ₽',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final item = expenses[index];

                            return InkWell(
                              onTap: () {
                                // TODO: route to transaction screen
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.comment ?? ''),
                                    Row(
                                      children: [
                                        Text(
                                          '${item.amount.toStringAsFixed(2)} ₽',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(width: 24),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
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
  }
}
