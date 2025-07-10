import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/utils/number_utils.dart';
import 'package:go_router/go_router.dart';

class AccountBalanceTile extends StatelessWidget {
  const AccountBalanceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/account/edit');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  radius: 12,
                  child: const Text('💰'),
                ),
                const SizedBox(width: 8),
                const Text('Баланс'),
              ],
            ),
            BlocBuilder<AccountBloc, AccountBlocState>(
              builder: (context, state) {
                if (state is AccountBlocLoaded) {
                  final balance = state.account.moneyDetails.balance;
                  final currency = state.account.moneyDetails.currency;
                  return Row(
                    children: [
                      Text(formatCurrency(value: balance, currency: currency)),
                      const SizedBox(width: 16),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
