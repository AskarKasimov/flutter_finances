import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/ui/tabs/transactions/transaction_creation_sheet.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_list.dart';
import 'package:go_router/go_router.dart';

class TransactionsScreen extends StatelessWidget {
  final bool isIncome;

  const TransactionsScreen({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return _TransactionsTodayView(isIncome: isIncome);
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
              context.go(isIncome ? '/incomes/history' : '/expenses/history');
            },
            icon: const Icon(Icons.history_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (sheetContext) => TransactionCreationSheet(
              parentContext: context,
              isIncome: isIncome,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
          switch (state) {
            case TransactionHistoryLoading():
              return const Center(child: CircularProgressIndicator());
            case TransactionHistoryError():
              return Center(child: Text('Ошибка: ${state.message}'));
            case TransactionHistoryLoaded():
              final transactions = state.transactions;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TransactionHistoryBloc>().add(
                    LoadTransactionHistory(
                      startDate: state.startDate,
                      endDate: state.endDate,
                      isIncome: isIncome,
                    ),
                  );
                },
                child: transactions.isEmpty
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Добавь нажатием на плюсик :)',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
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
                          print(
                            'Navigating to: ${isIncome ? '/incomes/transaction/${tx.id}' : '/expenses/transaction/${tx.id}'}',
                          );
                          context.go(
                            isIncome
                                ? '/incomes/transaction/${tx.id}'
                                : '/expenses/transaction/${tx.id}',
                            extra: context.read<TransactionHistoryBloc>(),
                          );
                        },
                      ),
              );
          }
        },
      ),
    );
  }
}
