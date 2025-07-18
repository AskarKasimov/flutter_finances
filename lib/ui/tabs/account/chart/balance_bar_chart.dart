import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/ui/tabs/account/chart/balance_segmented_controls.dart';
import 'package:flutter_finances/utils/date_utils.dart';
import 'package:flutter_finances/utils/number_utils.dart';

class BalanceBarChart extends StatelessWidget {
  final StatsPeriod selectedPeriod;
  final String currency;
  final List<Category> categories;

  const BalanceBarChart({
    super.key,
    required this.selectedPeriod,
    required this.currency,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        if (state is TransactionHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TransactionHistoryLoaded) {
          final transactions = state.transactions;

          final grouped = selectedPeriod == StatsPeriod.day
              ? _groupTransactionsByDay(transactions, categories)
              : _groupTransactionsByMonth(transactions, categories);

          final sortedEntries = [...grouped.entries]
            ..sort((a, b) => a.key.compareTo(b.key));

          if (sortedEntries.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noDataFound));
          }

          final screenWidth = MediaQuery.of(context).size.width;
          const minLabelWidth = 50.0;
          final maxLabels = (screenWidth / minLabelWidth).floor();
          final step = (sortedEntries.length / maxLabels).ceil().clamp(
            1,
            sortedEntries.length,
          );

          return SizedBox(
            height: 220,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 50, 0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final date = sortedEntries[group.x].key;
                        final value = sortedEntries[group.x].value;

                        final dateLabel = selectedPeriod == StatsPeriod.day
                            ? formatDateTimeShort(date)
                            : '${date.year}-${date.month.toString().padLeft(2, '0')}';
                        final amountLabel = formatCurrency(
                          value: value,
                          currency: currency,
                        );

                        return BarTooltipItem(
                          '$dateLabel\n$amountLabel',
                          TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),

                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 70,
                        getTitlesWidget: (value, meta) {
                          if (value % 10 != 0) return const SizedBox.shrink();
                          return Text(
                            formatNumber(value: value),
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index % step != 0) {
                            return const SizedBox.shrink();
                          }
                          final date = sortedEntries[index].key;
                          final label = selectedPeriod == StatsPeriod.day
                              ? formatDateTimeShort(date)
                              : '${date.year}-${date.month.toString().padLeft(2, '0')}';
                          return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text(
                              label,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (int i = 0; i < sortedEntries.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: sortedEntries[i].value.abs(),
                            width: 6,
                            color: sortedEntries[i].value >= 0
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                  ],
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Map<DateTime, double> _groupTransactionsByDay(
    List<Transaction> transactions,
    List<Category> categories,
  ) {
    final Map<DateTime, double> result = {};

    for (final t in transactions) {
      final day = DateTime(
        t.timestamp.year,
        t.timestamp.month,
        t.timestamp.day,
      );
      result.update(day, (v) => v + t.amount, ifAbsent: () => t.amount);
    }

    return result;
  }

  Map<DateTime, double> _groupTransactionsByMonth(
    List<Transaction> transactions,
    List<Category> categories,
  ) {
    final Map<DateTime, double> result = {};

    for (final t in transactions) {
      final month = DateTime(t.timestamp.year, t.timestamp.month);
      result.update(month, (v) => v + t.amount, ifAbsent: () => t.amount);
    }

    return result;
  }
}
