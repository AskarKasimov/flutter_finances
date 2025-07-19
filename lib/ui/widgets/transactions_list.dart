import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/widgets/sort_mode.dart';
import 'package:flutter_finances/utils/color_utils.dart';
import 'package:flutter_finances/utils/date_utils.dart';
import 'package:flutter_finances/utils/number_utils.dart';

class TransactionsList extends StatefulWidget {
  final List<Transaction> transactions;
  final void Function(Transaction) onTapTransaction;
  final bool showTime;
  final bool showSortMethods;
  final String currency;

  const TransactionsList({
    super.key,
    required this.transactions,
    required this.onTapTransaction,
    this.showTime = false,
    this.showSortMethods = false,
    required this.currency,
  });

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  late SortMode _sortMode;

  @override
  void initState() {
    super.initState();
    _sortMode = SortMode.values.first;
  }

  List<Transaction> get sortedTransactions =>
      _sortMode.sort(widget.transactions);

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
                    AppLocalizations.of(context)!.transactionsEmpty,
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
              alignment: Alignment.centerRight,
              child: PopupMenuButton<SortMode>(
                onSelected: (value) => setState(() => _sortMode = value),
                itemBuilder: (context) => SortMode.values.map((mode) {
                  return PopupMenuItem(
                    value: mode,
                    child: Text(mode.getLabel(context)),
                  );
                }).toList(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sort, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      _sortMode.getLabel(context),
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
                formatCurrency(value: totalSum, currency: widget.currency),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoaded) {
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final item = transactions[index];
                    final category = state.categories.firstWhere(
                      (cat) => cat.id == item.categoryId,
                    );
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
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: generateLightColorFromId(
                                      category.id,
                                    ),
                                    child: Text(
                                      category.emoji,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child:
                                        item.comment != null &&
                                            item.comment!.isNotEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                category.name,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                item.comment!,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )
                                        : Text(
                                            category.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                widget.showTime
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            formatCurrency(
                                              value: item.amount,
                                              currency: widget.currency,
                                            ),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                          Text(
                                            formatDateTime(item.timestamp),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      )
                                    : Text(
                                        formatCurrency(
                                          value: item.amount,
                                          currency: widget.currency,
                                        ),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
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
                );
              } else if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.errorLoadingCategories,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
