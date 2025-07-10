import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';

class TransactionsCategoryList extends StatelessWidget {
  const TransactionsCategoryList({super.key});

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

            final transactions = txState.transactions;
            final total = transactions.fold<double>(
              0,
              (sum, tx) => sum + tx.amount,
            );

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
                final sumA = a.value.fold<double>(
                  0,
                  (sum, tx) => sum + tx.amount,
                );
                final sumB = b.value.fold<double>(
                  0,
                  (sum, tx) => sum + tx.amount,
                );
                return sumB.compareTo(sumA);
              });

            return Column(
              children: entries.map((entry) {
                final categoryId = entry.key;
                final category = catState.categories.firstWhere(
                  (c) => c.id == categoryId,
                );
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
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final Category category;
  final List<Transaction> transactions;
  final double totalSum;
  final double percent;
  final String? comment;

  const _CategoryTile({
    required this.category,
    required this.transactions,
    required this.totalSum,
    required this.percent,
    required this.comment,
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
                    backgroundColor: _generateColorFromId(
                      widget.category.id,
                    ).withValues(alpha: 0.15),
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
                        '${(widget.percent * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        '${widget.totalSum.toStringAsFixed(0)} ₽',
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
                        '${tx.amount.toStringAsFixed(2)} ₽',
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

  Color _generateColorFromId(int id) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];
    return colors[id % colors.length];
  }
}
