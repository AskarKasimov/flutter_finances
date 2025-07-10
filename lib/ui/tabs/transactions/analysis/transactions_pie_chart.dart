import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';

class TransactionsPieChartSection extends StatelessWidget {
  const TransactionsPieChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, txState) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, catState) {
            if (txState is! TransactionHistoryLoaded ||
                catState is! CategoryLoaded) {
              return const SizedBox.shrink();
            }

            final total = txState.transactions.fold<double>(
              0,
              (sum, tx) => sum + tx.amount,
            );

            final Map<int, double> sumsByCategory = {};
            for (final tx in txState.transactions) {
              sumsByCategory[tx.categoryId!] =
                  (sumsByCategory[tx.categoryId!] ?? 0) + tx.amount;
            }

            final entries =
                sumsByCategory.entries.map((entry) {
                  final category = catState.categories.firstWhere(
                    (c) => c.id == entry.key,
                  );
                  final percent = total > 0 ? entry.value / total : 0.0;
                  final color = _generateColorFromId(entry.key);

                  return (
                    categoryId: entry.key,
                    percent: percent,
                    legendText:
                        '${(percent * 100).toStringAsFixed(0)}% ${category.name}',
                    color: color,
                    emoji: category.emoji,
                  );
                }).toList()..sort(
                  (a, b) => b.percent.compareTo(a.percent),
                ); // Top 3 first

            final sections = entries.map((entry) {
              return PieChartSectionData(
                color: entry.color,
                value: entry.percent,
                radius: 36,
                title: '',
                badgeWidget: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    entry.legendText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                badgePositionPercentageOffset: 1.3,
              );
            }).toList();

            final top3 = entries.take(3).toList();

            return AspectRatio(
              aspectRatio: 1.3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 80,
                      sections: sections,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: top3
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  e.emoji,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  e.legendText,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _generateColorFromId(int id) {
    final colors = [
      Colors.green,
      Colors.yellow,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.indigo,
      Colors.brown,
    ];
    return colors[id % colors.length];
  }
}
