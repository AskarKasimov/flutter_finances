import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        child: ListView(
          children: [
            const TransactionsFilterSection(),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            const TransactionsSummarySection(),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            const TransactionsPieChartSection(),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            const TransactionsCategoryList(),
          ],
        ),
      ),
    );
  }
}
