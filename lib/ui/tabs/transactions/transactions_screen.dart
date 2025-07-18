import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/ui/tabs/transactions/transaction_creation_sheet.dart';
import 'package:flutter_finances/ui/widgets/transactions_list.dart';
import 'package:go_router/go_router.dart';

class TransactionsScreen extends StatelessWidget {
  final bool isIncome;

  const TransactionsScreen({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isIncome ? AppLocalizations.of(context)!.incomesToday : AppLocalizations.of(context)!.expensesToday),
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
          HapticFeedback.lightImpact();
          showTransactionCreationSheet(context: context, isIncome: isIncome);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (transactionContext, transactionState) {
          return BlocBuilder<AccountBloc, AccountBlocState>(
            builder: (accountContext, accountState) {
              if (transactionState is TransactionHistoryLoading ||
                  accountState is AccountBlocLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (transactionState is TransactionHistoryError) {
                return Center(
                  child: Text('${AppLocalizations.of(context)!.errorTitle}: ${transactionState.message}'),
                );
              }

              if (accountState is AccountBlocError) {
                return Center(child: Text('${AppLocalizations.of(context)!.errorTitle}: ${accountState.message}'));
              }

              if (transactionState is TransactionHistoryLoaded &&
                  accountState is AccountBlocLoaded) {
                final transactions = transactionState.transactions;

                return RefreshIndicator(
                  onRefresh: () async {
                    transactionContext.read<TransactionHistoryBloc>().add(
                      LoadTransactionHistory(
                        startDate: transactionState.startDate,
                        endDate: transactionState.endDate,
                        isIncome: isIncome,
                      ),
                    );
                  },
                  child: transactions.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(
                                    transactionContext,
                                  ).size.height /
                                  2,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isIncome
                                          ? AppLocalizations.of(context)!.incomesEmptyToday
                                          : AppLocalizations.of(context)!.expensesEmptyToday,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppLocalizations.of(context)!.addByPlus,
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
                            transactionContext.go(
                              isIncome
                                  ? '/incomes/transaction/${tx.id}'
                                  : '/expenses/transaction/${tx.id}',
                            );
                          },
                          currency: accountState.account.moneyDetails.currency,
                        ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
