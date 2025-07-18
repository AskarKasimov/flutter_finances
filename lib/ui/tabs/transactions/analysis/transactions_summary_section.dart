import 'package:flutter/material.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/utils/number_utils.dart';

class TransactionsSummarySection extends StatelessWidget {
  final List<Transaction> transactions;
  final String currency;

  const TransactionsSummarySection({
    super.key,
    required this.transactions,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final total = transactions.fold<double>(0, (sum, tx) => sum + tx.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.summa),
          Text(
            formatCurrency(value: total, currency: currency),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
