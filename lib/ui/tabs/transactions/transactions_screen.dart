import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/ui/blocs/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions_history_state.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_list.dart';
import 'package:go_router/go_router.dart';

class TransactionsScreen extends StatelessWidget {
  final bool isIncome;

  const TransactionsScreen({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
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
      child: _TransactionsTodayView(isIncome: isIncome),
    );
  }
}

class _TransactionsTodayView extends StatelessWidget {
  final bool isIncome;

  const _TransactionsTodayView({required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isIncome ? 'Доходы сегодня' : 'Расходы сегодня'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.go(isIncome ? '/income/history' : '/expenses/history');
            },
            icon: const Icon(Icons.history_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: переход к созданию транзакции
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
          if (state is TransactionHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionHistoryError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is TransactionHistoryLoaded) {
            final transactions = state.transactions;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionHistoryBloc>().add(
                  LoadTransactionHistory(
                    startDate: state.startDate,
                    endDate: state.endDate,
                  ),
                );
              },
              child:
                  transactions.isEmpty
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
                                    isIncome
                                        ? 'Здесь будут твои доходы за день'
                                        : 'Здесь будут твои расходы за день',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Добавь нажатием на плюсик :)',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                      : TransactionsList(
                        transactions: transactions,
                        showTime: false,
                        showSortMethods: false,
                        onTapTransaction: (tx) {
                          // TODO: переход к деталям транзакции
                        },
                      ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
