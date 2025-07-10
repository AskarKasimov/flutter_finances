import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/utils/color_utils.dart';

class TransactionsPieChartSection extends StatefulWidget {
  const TransactionsPieChartSection({super.key});

  @override
  State<TransactionsPieChartSection> createState() =>
      _TransactionsPieChartSectionState();
}

class _TransactionsPieChartSectionState
    extends State<TransactionsPieChartSection> {
  int? touchedIndex;

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

            final sortedEntries = sumsByCategory.entries.toList()
              ..sort((a, b) => a.value.compareTo(b.value));

            final top3Ids = sortedEntries.reversed
                .take(3)
                .map((e) => e.key)
                .toSet();

            final entries = sortedEntries.map((entry) {
              final category = catState.categories.firstWhere(
                (c) => c.id == entry.key,
              );
              final percent = total > 0 ? entry.value / total : 0.0;
              final index = sortedEntries.indexOf(entry);
              final color = generateColorFromId(entry.key);

              return (
                section: PieChartSectionData(
                  color: color,
                  value: percent,
                  title: '',
                  radius: touchedIndex == index ? 42 : 36,
                  badgeWidget: touchedIndex == index
                      ? _BadgeWidget(
                          emoji: category.emoji,
                          name: category.name,
                          color: color,
                          percentage: top3Ids.contains(entry.key)
                              ? null
                              : '${(percent * 100).toStringAsFixed(2)}%',
                        )
                      : null,
                  badgePositionPercentageOffset: 1.3,
                ),
                legendText:
                    '${(percent * 100).toStringAsFixed(0)}% ${category.name}',
                color: color,
              );
            }).toList();

            final top3 = entries.reversed.take(3).toList();

            return AspectRatio(
              aspectRatio: 1.3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 90,
                      startDegreeOffset: -90,
                      sections: entries.map((e) => e.section).toList(),
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            touchedIndex =
                                response?.touchedSection?.touchedSectionIndex;
                          });
                        },
                      ),
                    ),
                  ),
                  _TopCategories(top3: top3),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BadgeWidget extends StatelessWidget {
  final String emoji;
  final String name;
  final Color color;
  final String? percentage;

  const _BadgeWidget({
    required this.emoji,
    required this.name,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 120),
      // лимит ширины
      child: Text(
        percentage == null ? '$emoji $name' : '$percentage $emoji $name',
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

class _TopCategories extends StatelessWidget {
  final List<({Color color, String legendText, PieChartSectionData section})>
  top3;

  const _TopCategories({required this.top3});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: top3
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 10, color: e.color),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 140,
                    child: Text(
                      e.legendText,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
