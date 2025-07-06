import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/gen/assets.gen.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_event.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/tabs/account/currency.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:spoiler_widget/spoiler_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final StreamSubscription<AccelerometerEvent> _accelerometerSub;
  bool _spoilerEnabled = false;
  bool _wasFacingDown = false;

  @override
  void initState() {
    super.initState();

    _accelerometerSub = accelerometerEventStream().listen((event) {
      final z = event.z;

      // Z ~ -9.8 => экран вниз, Z ~ 9.8 => экран вверх
      if (z < -9) {
        _wasFacingDown = true;
      }

      if (_wasFacingDown && z > 9) {
        setState(() {
          _spoilerEnabled = true;
        });
        _wasFacingDown = false;
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой счет'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.go('/account/edit');
            },
            icon: Assets.icons.edit.svg(width: 18, height: 18),
          ),
        ],
      ),
      body: BlocBuilder<AccountBloc, AccountBlocState>(
        builder: (context, state) {
          return switch (state) {
            AccountBlocInitial() || AccountBlocLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            AccountBlocError(:final message) => Center(
              child: Text('Ошибка: $message'),
            ),
            AccountBlocLoaded(:final account) => Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(account.name),
                      SpoilerText(
                        text:
                            '${account.moneyDetails.balance.toStringAsFixed(0)} ${account.moneyDetails.currency}',
                        config: TextSpoilerConfig(
                          isEnabled: _spoilerEnabled,
                          enableFadeAnimation: true,
                          enableGestureReveal: true,
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          particleColor: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Theme.of(context).dividerColor),
                InkWell(
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
                        Text(account.moneyDetails.currency),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}
