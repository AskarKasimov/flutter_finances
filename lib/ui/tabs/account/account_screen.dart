import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/gen/assets.gen.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_event.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/tabs/account/account_balance_tile.dart';
import 'package:flutter_finances/ui/tabs/account/account_currency_tile.dart';
import 'package:flutter_finances/ui/tabs/account/chart/balance_bar_chart.dart';
import 'package:flutter_finances/ui/tabs/account/chart/balance_segmented_controls.dart';
import 'package:flutter_finances/utils/date_utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  StatsPeriod _selectedPeriod = StatsPeriod.day;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<TransactionHistoryBloc>();
    bloc.add(
      LoadTransactionHistory(
        startDate: startThisMonth(),
        endDate: endThisDay(),
        isIncome: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myAccount),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Assets.icons.edit.svg(width: 18, height: 18),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AccountBloc>().add(LoadAccount(154));
          context.read<TransactionHistoryBloc>().add(
            LoadTransactionHistory(
              startDate: startThisMonth(),
              endDate: endThisDay(),
              isIncome: null,
            ),
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocBuilder<AccountBloc, AccountBlocState>(
            builder: (accountContext, accountState) {
              return BlocBuilder<CategoryBloc, CategoryState>(
                builder: (categoriesContext, categoriesState) {
                  if (accountState is AccountBlocLoading ||
                      categoriesState is CategoryLoading) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  }
                  if (accountState is AccountBlocError) {
                    return Center(child: Text(accountState.message));
                  }
                  if (categoriesState is CategoryError) {
                    return Center(child: Text(categoriesState.message));
                  }
                  if (accountState is AccountBlocLoaded &&
                      categoriesState is CategoryLoaded) {
                    return Column(
                      children: [
                        const AccountBalanceTile(),
                        Divider(
                          height: 1,
                          color: Theme.of(accountContext).dividerColor,
                        ),
                        const AccountCurrencyTile(),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: BalanceSegmentedControls(
                            selectedPeriod: _selectedPeriod,
                            onChanged: (selected) {
                              setState(() {
                                _selectedPeriod = selected;
                              });

                              final now = DateTime.now();
                              final startDate = selected == StatsPeriod.day
                                  ? startThisMonth()
                                  : DateTime(now.year - 1, now.month);
                              final endDate = endThisDay();

                              context.read<TransactionHistoryBloc>().add(
                                LoadTransactionHistory(
                                  startDate: startDate,
                                  endDate: endDate,
                                  isIncome: null,
                                ),
                              );
                            },
                          ),
                        ),
                        BalanceBarChart(
                          selectedPeriod: _selectedPeriod,
                          currency: accountState.account.moneyDetails.currency,
                          categories: categoriesState.categories,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
