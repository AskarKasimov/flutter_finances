import 'package:flutter/material.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(Transaction) onTapTransaction;
  final bool showTime;

  const TransactionsList({
    super.key,
    required this.transactions,
    required this.onTapTransaction,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
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
                  const SizedBox(height: 4),
                  Text(
                    'Добавь нажатием на плюсик :)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final totalSum = transactions.fold<double>(0, (sum, tx) => sum + tx.amount);

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Всего'),
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
                onTap: () => onTapTransaction(item),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: showTime ? 14 : 20,
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
                          showTime
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${item.amount.toStringAsFixed(2)} ₽',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}',
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
