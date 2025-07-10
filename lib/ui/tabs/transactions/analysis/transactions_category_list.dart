import 'package:flutter/material.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/utils/color_utils.dart';
import 'package:flutter_finances/utils/number_utils.dart';

class TransactionsCategoryList extends StatelessWidget {
  final List<Transaction> transactions;
  final List<Category> categories;
  final String currency;

  const TransactionsCategoryList({
    super.key,
    required this.transactions,
    required this.categories,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final total = transactions.fold<double>(0, (sum, tx) => sum + tx.amount);

    final Map<int, List<Transaction>> transactionsByCategory = {};
    for (final tx in transactions) {
      final categoryId = tx.categoryId;
      if (categoryId != null) {
        transactionsByCategory.putIfAbsent(categoryId, () => []);
        transactionsByCategory[categoryId]!.add(tx);
      }
    }

    final entries = transactionsByCategory.entries.toList()
      ..sort((a, b) {
        final sumA = a.value.fold<double>(0, (sum, tx) => sum + tx.amount);
        final sumB = b.value.fold<double>(0, (sum, tx) => sum + tx.amount);
        return sumB.compareTo(sumA);
      });

    return Column(
      children: entries.map((entry) {
        final categoryId = entry.key;
        final category = categories.firstWhere((c) => c.id == categoryId);
        final categoryTransactions = entry.value;

        final sum = categoryTransactions.fold<double>(
          0,
          (sum, tx) => sum + tx.amount,
        );
        final percent = total > 0 ? sum / total : 0.0;

        final lastTx = categoryTransactions.reduce(
          (a, b) => a.timestamp.isAfter(b.timestamp) ? a : b,
        );

        return _CategoryTile(
          category: category,
          transactions: categoryTransactions,
          totalSum: sum,
          percent: percent,
          comment: lastTx.comment,
          currency: currency,
        );
      }).toList(),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final Category category;
  final List<Transaction> transactions;
  final double totalSum;
  final double percent;
  final String? comment;
  final String currency;

  const _CategoryTile({
    required this.category,
    required this.transactions,
    required this.totalSum,
    required this.percent,
    required this.comment,
    required this.currency,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: generateLightColorFromId(
                      widget.category.id,
                    ),
                    child: Text(widget.category.emoji),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (widget.comment?.isNotEmpty == true)
                          Text(
                            widget.comment!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(widget.percent * 100).toStringAsFixed(2)}%',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        formatCurrency(
                          value: widget.totalSum,
                          currency: widget.currency,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_right,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 16, bottom: 8),
            child: Column(
              children: widget.transactions.map((tx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (tx.comment != null)
                        Text(
                          tx.comment!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      Text(
                        formatCurrency(
                          value: tx.amount,
                          currency: widget.currency,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
