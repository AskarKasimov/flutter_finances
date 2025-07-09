import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/tabs/account/account_screen.dart';
import 'package:flutter_finances/utils/date_utils.dart';
import 'package:flutter_finances/utils/number_utils.dart';


class BalanceBarChart extends StatelessWidget {
  final Map<DateTime, double> groupedBalance;
  final StatsPeriod selectedPeriod;
  final String currency;

  const BalanceBarChart({
    super.key,
    required this.groupedBalance,
    required this.selectedPeriod,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEntries = groupedBalance.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (sortedEntries.isEmpty) {
      return const Center(child: Text('Нет данных для отображения'));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    const minLabelWidth = 24.0;
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
                  final value = sortedEntries[group.x].value;
                  return BarTooltipItem(
                    '${value.toString()} $currency',
                    const TextStyle(
                      color: Colors.white,
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
                      formatNumber(value),
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
                    if (index < 0 ||
                        index >= sortedEntries.length ||
                        index % step != 0) {
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
}
