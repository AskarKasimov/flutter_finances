import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/ui/tabs/transactions/analysis/transactions_category_list.dart';
import 'package:flutter_finances/ui/tabs/transactions/analysis/transactions_filter_section.dart';
import 'package:flutter_finances/ui/tabs/transactions/analysis/transactions_pie_chart.dart';
import 'package:flutter_finances/ui/tabs/transactions/analysis/transactions_summary_section.dart';

class TransactionsAnalysisScreen extends StatelessWidget {
  const TransactionsAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Анализ'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final bloc = context.read<TransactionHistoryBloc>();
          final state = bloc.state;
          if (state is TransactionHistoryLoaded) {
            bloc.add(
              LoadTransactionHistory(
                startDate: state.startDate,
                endDate: state.endDate,
                isIncome: state.isIncome,
              ),
            );
          }
        },
        child: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
          builder: (transactionContext, transactionState) {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (categoryContext, categoryState) {
                return BlocBuilder<AccountBloc, AccountBlocState>(
                  builder: (accountContext, accountState) {
                    if (transactionState is TransactionHistoryLoading ||
                        categoryState is CategoryLoading ||
                        accountState is AccountBlocLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (transactionState is TransactionHistoryError) {
                      return Center(
                        child: Text('Ошибка: ${transactionState.message}'),
                      );
                    }

                    if (categoryState is CategoryError) {
                      return Center(
                        child: Text('Ошибка: ${categoryState.message}'),
                      );
                    }

                    if (accountState is AccountBlocError) {
                      return Center(
                        child: Text('Ошибка: ${accountState.message}'),
                      );
                    }

                    if (transactionState is TransactionHistoryLoaded &&
                        categoryState is CategoryLoaded &&
                        accountState is AccountBlocLoaded) {
                      return ListView(
                        children: [
                          TransactionsFilterSection(
                            startDate: transactionState.startDate,
                            endDate: transactionState.endDate,
                            isIncome: transactionState.isIncome,
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          TransactionsSummarySection(
                            transactions: transactionState.transactions,
                            currency:
                                accountState.account.moneyDetails.currency,
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          TransactionsPieChartSection(
                            transactions: transactionState.transactions,
                            categories: categoryState.categories,
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          TransactionsCategoryList(
                            transactions: transactionState.transactions,
                            categories: categoryState.categories,
                            currency:
                                accountState.account.moneyDetails.currency,
                          ),
                        ],
                      );
                    }

                    return const Center(
                      child: Text('Нет данных для отображения'),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
