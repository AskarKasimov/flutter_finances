import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';

class TransactionsSummarySection extends StatelessWidget {
  const TransactionsSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, txState) {
        return BlocBuilder<AccountBloc, AccountBlocState>(
          builder: (context, accState) {
            if (txState is! TransactionHistoryLoaded ||
                accState is! AccountBlocLoaded) {
              return const SizedBox.shrink();
            }

            final total = txState.transactions.fold<double>(
              0,
              (sum, tx) => sum + tx.amount,
            );

            return Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Сумма'),
                  Text(
                    '$total ${accState.account.moneyDetails.currency}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
