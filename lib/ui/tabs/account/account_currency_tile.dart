import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_event.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';

class AccountCurrencyTile extends StatelessWidget {
  const AccountCurrencyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selected = await showCurrencyPicker(context);
        if (selected != null) {
          context.read<AccountBloc>().add(ChangeCurrency(selected));
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Валюта'),
            BlocBuilder<AccountBloc, AccountBlocState>(
              builder: (context, state) {
                if (state is AccountBlocLoaded) {
                  return Row(
                    children: [
                      Text(state.account.moneyDetails.currency),
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

Future<String?> showCurrencyPicker(BuildContext context) {
  return showModalBottomSheet<String>(
    useRootNavigator: true,
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Text('₽', style: TextStyle(fontSize: 20)),
            title: const Text('Российский рубль ₽'),
            onTap: () => Navigator.of(context).pop('₽'),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListTile(
            leading: const Text('\$', style: TextStyle(fontSize: 20)),
            title: const Text('Американский доллар \$'),
            onTap: () => Navigator.of(context).pop('\$'),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListTile(
            leading: const Text('€', style: TextStyle(fontSize: 20)),
            title: const Text('Евро'),
            onTap: () => Navigator.of(context).pop('€'),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.white),
            title: const Text('Отмена', style: TextStyle(color: Colors.white)),
            tileColor: Colors.redAccent,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
