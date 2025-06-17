import 'package:flutter/material.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/ui/navigation/tab_screen_interface.dart';

class ExpensesScreen extends StatefulWidget implements TabScreen {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();

  @override
  IconData get tabIcon => Icons.trending_down_outlined;

  @override
  String get tabLabel => 'Расходы';

  @override
  AppBar get appBar =>
      AppBar(title: const Text('Расходы сегодня'), centerTitle: true);

  @override
  String get routePath => '/expenses';

  @override
  Widget? get floatingActionButton => FloatingActionButton(
    onPressed: () {
      // TODO: route to add transaction screen
    },
    child: const Icon(Icons.add),
  );
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late Future<List<Transaction>> _futureExpenses;

  @override
  void initState() {
    super.initState();
    _futureExpenses = _loadTransactions();
  }

  Future<List<Transaction>> _loadTransactions() async {
    final result = await MockedTransactionRepository().getTransactionsByPeriod(
      1,
      null,
      null,
    );

    return result.fold((failure) => [], (transactions) => transactions);
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

        if (expenses.isEmpty) {
          return RefreshIndicator(
            // forcibly made scrollable to enable pull-to-refresh
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Здесь будут твои расходы',
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
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(item.comment ?? '')],
                      ),
                      Row(
                        children: [
                          Text(
                            '${item.amount.toStringAsFixed(2)} ₽',
                            style: Theme.of(context).textTheme.bodyMedium,
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
        );
      },
    );
  }
}
