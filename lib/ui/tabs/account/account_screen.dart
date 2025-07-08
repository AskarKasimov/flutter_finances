import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/gen/assets.gen.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_event.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_state.dart';
import 'package:flutter_finances/ui/tabs/account/currency.dart';
import 'package:flutter_finances/utils/date_utils.dart';
import 'package:flutter_finances/utils/number_utils.dart';
import 'package:go_router/go_router.dart';

enum StatsPeriod { day, month }

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

  Map<DateTime, double> _groupTransactionsByDay(
    List transactions,
    List categories,
  ) {
    final categoryById = {for (var c in categories) c.id: c};
    final Map<DateTime, double> dailyBalance = {};

    for (final tx in transactions) {
      final day = DateTime(
        tx.timestamp.year,
        tx.timestamp.month,
        tx.timestamp.day,
      );

      final category = categoryById[tx.categoryId];
      if (category == null) continue;

      final amount = category.isIncome ? tx.amount : -tx.amount;

      dailyBalance.update(
        day,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    return dailyBalance;
  }

  Map<DateTime, double> _groupTransactionsByMonth(
    List transactions,
    List categories,
  ) {
    final categoryById = {for (var c in categories) c.id: c};
    final Map<DateTime, double> monthlyBalance = {};

    for (final tx in transactions) {
      final month = DateTime(tx.timestamp.year, tx.timestamp.month);

      final category = categoryById[tx.categoryId];
      if (category == null) continue;

      final amount = category.isIncome ? tx.amount : -tx.amount;

      monthlyBalance.update(
        month,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    return monthlyBalance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой счет'),
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (accountState is AccountBlocError) {
                    return Center(
                      child: Text('Ошибка: ${accountState.message}'),
                    );
                  }
                  if (categoriesState is CategoryError) {
                    return Center(
                      child: Text('Ошибка: ${categoriesState.message}'),
                    );
                  }
                  if (accountState is AccountBlocLoaded &&
                      categoriesState is CategoryLoaded) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            accountContext.go('/account/edit');
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: Theme.of(
                              accountContext,
                            ).colorScheme.secondary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(
                                        accountContext,
                                      ).scaffoldBackgroundColor,
                                      radius: 12,
                                      child: const Text('💰'),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Баланс'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${accountState.account.moneyDetails.balance.toStringAsFixed(0)} ${accountState.account.moneyDetails.currency}',
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(accountContext).dividerColor,
                        ),
                        InkWell(
                          onTap: () async {
                            final selected = await showCurrencyPicker(
                              accountContext,
                            );
                            if (selected != null) {
                              accountContext.read<AccountBloc>().add(
                                ChangeCurrency(selected),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: Theme.of(
                              accountContext,
                            ).colorScheme.secondary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Валюта'),
                                Row(
                                  children: [
                                    Text(
                                      accountState
                                          .account
                                          .moneyDetails
                                          .currency,
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: SizedBox(
                            width: double.infinity,
                            child: SegmentedButton<StatsPeriod>(
                              segments: const [
                                ButtonSegment(
                                  value: StatsPeriod.day,
                                  label: Text('По дням'),
                                ),
                                ButtonSegment(
                                  value: StatsPeriod.month,
                                  label: Text('По месяцам'),
                                ),
                              ],
                              selected: {_selectedPeriod},
                              onSelectionChanged: (newSelection) {
                                final selected = newSelection.first;
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
                        ),

                        BlocBuilder<
                          TransactionHistoryBloc,
                          TransactionHistoryState
                        >(
                          builder: (context, state) {
                            if (state is TransactionHistoryLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is TransactionHistoryLoaded) {
                              final transactions = state.transactions;

                              final Map<DateTime, double> groupedBalance =
                                  _selectedPeriod == StatsPeriod.day
                                  ? _groupTransactionsByDay(
                                      transactions,
                                      categoriesState.categories,
                                    )
                                  : _groupTransactionsByMonth(
                                      transactions,
                                      categoriesState.categories,
                                    );

                              final sortedEntries = [...groupedBalance.entries]
                                ..sort((a, b) => a.key.compareTo(b.key));

                              if (sortedEntries.isEmpty) {
                                return const Center(
                                  child: Text('Нет данных для отображения'),
                                );
                              }

                              final screenWidth = MediaQuery.of(
                                context,
                              ).size.width;
                              const minLabelWidth = 24.0;
                              final maxLabels = (screenWidth / minLabelWidth)
                                  .floor();
                              final step = (sortedEntries.length / maxLabels)
                                  .ceil()
                                  .clamp(1, sortedEntries.length);

                              return SizedBox(
                                height: 220,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    10,
                                    25,
                                    50,
                                    0,
                                  ),
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceBetween,
                                      barTouchData: BarTouchData(
                                        enabled: true,
                                        touchTooltipData: BarTouchTooltipData(
                                          getTooltipItem:
                                              (
                                                group,
                                                groupIndex,
                                                rod,
                                                rodIndex,
                                              ) {
                                                final value =
                                                    sortedEntries[group.x]
                                                        .value;
                                                return BarTooltipItem(
                                                  '${value.toString()} ${accountState.account.moneyDetails.currency}',
                                                  TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        topTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 70,
                                            getTitlesWidget: (value, meta) {
                                              if (value % 10 != 0) {
                                                return const SizedBox.shrink();
                                              }
                                              return Text(
                                                formatNumber(value),
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              );
                                            },
                                          ),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 1,
                                            getTitlesWidget: (value, meta) {
                                              final index = value.toInt();
                                              if (index < 0 ||
                                                  index >=
                                                      sortedEntries.length ||
                                                  index % step != 0) {
                                                return const SizedBox.shrink();
                                              }
                                              final date =
                                                  sortedEntries[index].key;
                                              final label =
                                                  _selectedPeriod ==
                                                      StatsPeriod.day
                                                  ? formatDateTimeShort(date)
                                                  : '${date.year}-${date.month.toString().padLeft(2, '0')}';
                                              return SideTitleWidget(
                                                meta: meta,
                                                space: 4,
                                                child: Text(
                                                  label,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      barGroups: [
                                        for (
                                          int i = 0;
                                          i < sortedEntries.length;
                                          i++
                                        )
                                          BarChartGroupData(
                                            x: i,
                                            barRods: [
                                              BarChartRodData(
                                                toY: sortedEntries[i].value
                                                    .abs(),
                                                width: 6,
                                                color:
                                                    sortedEntries[i].value >= 0
                                                    ? Colors.green
                                                    : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ],
                                          ),
                                      ],
                                      gridData: FlGridData(show: false),
                                      borderData: FlBorderData(show: false),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
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
