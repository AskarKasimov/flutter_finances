import 'package:flutter/material.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/utils/date_utils.dart';

enum SortMode {
  dateDesc('Сначала новые'),
  dateAsc('Сначала старые'),
  amountDesc('Сначала большие суммы'),
  amountAsc('Сначала меньшие суммы');

  final String label;

  const SortMode(this.label);
}

class TransactionsList extends StatefulWidget {
  final List<Transaction> transactions;
  final void Function(Transaction) onTapTransaction;
  final bool showTime;
  final bool showSortMethods;

  const TransactionsList({
    super.key,
    required this.transactions,
    required this.onTapTransaction,
    this.showTime = false,
    this.showSortMethods = false,
  });

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  SortMode _sortMode = SortMode.dateDesc;

  List<Transaction> get sortedTransactions {
    final sorted = [...widget.transactions];
    sorted.sort((a, b) {
      switch (_sortMode) {
        case SortMode.dateDesc:
          return b.timestamp.compareTo(a.timestamp);
        case SortMode.dateAsc:
          return a.timestamp.compareTo(b.timestamp);
        case SortMode.amountDesc:
          return b.amount.compareTo(a.amount);
        case SortMode.amountAsc:
          return a.amount.compareTo(b.amount);
      }
    });
    return sorted;
  }

  String get sortLabel => _sortMode.label;

  @override
  Widget build(BuildContext context) {
    if (widget.transactions.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Здесь будут твои транзакции',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final transactions = sortedTransactions;
    final totalSum = transactions.fold<double>(0, (sum, tx) => sum + tx.amount);

    return Column(
      children: [
        if (widget.showSortMethods)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: PopupMenuButton<SortMode>(
                onSelected: (value) => setState(() => _sortMode = value),
                itemBuilder:
                    (context) =>
                        SortMode.values.map((mode) {
                          return PopupMenuItem(
                            value: mode,
                            child: Text(mode.label),
                          );
                        }).toList(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sort, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      sortLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Всего'),
              Text(
                '$totalSum ₽',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final item = transactions[index];
              return InkWell(
                onTap: () => widget.onTapTransaction(item),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: widget.showTime ? 14 : 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.comment ?? ''),
                      Row(
                        children: [
                          widget.showTime
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${item.amount.toStringAsFixed(2)} ₽',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    formatDateTime(item.timestamp),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              )
                              : Text(
                                '${item.amount.toStringAsFixed(2)} ₽',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          const SizedBox(width: 24),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
