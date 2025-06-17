import 'package:flutter/material.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/ui/navigation/tab_screen_interface.dart';

class ExpensesScreen extends StatelessWidget implements TabScreen {
  const ExpensesScreen({super.key});

  Future<List<Transaction>> _loadTransactions() async {
    final result = await MockedTransactionRepository().getTransactionsByPeriod(
      1,
      null,
      null,
    );

    return result.fold((failure) => [], (transactions) => transactions);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: _loadTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // loader
          return const Center(child: CircularProgressIndicator());
        }

        final expenses = snapshot.data ?? [];

        if (expenses.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Здесь будут твои расходы',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 4),
              Text(
                'Добавь нажатием на плюсик :)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        }

        return ListView.builder(
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
                        const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget? get floatingActionButton => FloatingActionButton(
    onPressed: () {
      // TODO: route to add transaction screen
    },
    child: const Icon(Icons.add),
  );

  @override
  IconData get tabIcon => Icons.trending_down_outlined;

  @override
  String get tabLabel => 'Расходы';

  @override
  AppBar get appBar =>
      AppBar(title: const Text('Расходы сегодня'), centerTitle: true);

  @override
  String get routePath => '/expenses';
}
