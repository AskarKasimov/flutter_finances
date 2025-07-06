import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period.dart';
import 'package:flutter_finances/gen/assets.gen.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/tabs/account/account_edit_name_screen.dart';
import 'package:flutter_finances/ui/tabs/account/account_screen.dart';
import 'package:flutter_finances/ui/tabs/items_screen.dart';
import 'package:flutter_finances/ui/tabs/settings_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transaction_edit_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_analysis.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_history_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_screen.dart';
import 'package:go_router/go_router.dart';

ColorFilter? _navIconColor(BuildContext context, bool isSelected) {
  return isSelected
      ? ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn)
      : null;
}

DateTime startThisDay() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 0, 0, 0);
}

DateTime startThisMonth() {
  final now = DateTime.now();
  return DateTime(now.year, now.month - 1, now.day, 0, 0, 0);
}

DateTime endThisDay() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 23, 59, 59);
}

final GoRouter router = GoRouter(
  initialLocation: '/expenses',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) {
        return Scaffold(
          body: shell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: (index) {
              if (index == shell.currentIndex) {
                shell.goBranch(index, initialLocation: true);
              } else {
                shell.goBranch(index);
              }
            },
            destinations: [
              NavigationDestination(
                icon: Assets.icons.expenses.svg(
                  width: 24,
                  height: 24,
                  colorFilter: _navIconColor(context, shell.currentIndex == 0),
                ),
                label: 'Расходы',
              ),
              NavigationDestination(
                icon: Assets.icons.income.svg(
                  width: 24,
                  height: 24,
                  colorFilter: _navIconColor(context, shell.currentIndex == 1),
                ),
                label: 'Доходы',
              ),
              NavigationDestination(
                icon: Assets.icons.account.svg(
                  width: 24,
                  height: 24,
                  colorFilter: _navIconColor(context, shell.currentIndex == 2),
                ),
                label: 'Счета',
              ),
              NavigationDestination(
                icon: Assets.icons.items.svg(
                  width: 24,
                  height: 24,
                  colorFilter: _navIconColor(context, shell.currentIndex == 3),
                ),
                label: 'Статьи',
              ),
              NavigationDestination(
                icon: Assets.icons.settings.svg(
                  width: 24,
                  height: 24,
                  colorFilter: _navIconColor(context, shell.currentIndex == 4),
                ),
                label: 'Настройки',
              ),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/expenses',
              builder: (context, state) => BlocProvider(
                create: (_) => TransactionHistoryBloc(
                  getTransactions: UseCaseGetTransactionsByPeriod(
                    context.read<MockedTransactionRepository>(),
                    context.read<MockedCategoryRepository>(),
                  ),
                  initialStartDate: startThisDay(),
                  initialEndDate: endThisDay(),
                  initialIsIncome: false,
                ),
                child: const TransactionsScreen(isIncome: false),
              ),
              routes: [
                GoRoute(
                  path: 'transaction/:transactionId',
                  builder: (context, state) {
                    final id = int.parse(
                      state.pathParameters['transactionId']!,
                    );
                    final bloc = state.extra as TransactionHistoryBloc?;
                    if (bloc == null) {
                      throw Exception(
                        'TransactionHistoryBloc must be passed as extra',
                      );
                    }
                    return BlocProvider.value(
                      value: bloc,
                      child: TransactionEditScreen(transactionId: id),
                    );
                  },
                ),
                GoRoute(
                  path: 'history',
                  builder: (context, state) => BlocProvider(
                    create: (_) => TransactionHistoryBloc(
                      getTransactions: UseCaseGetTransactionsByPeriod(
                        context.read<MockedTransactionRepository>(),
                        context.read<MockedCategoryRepository>(),
                      ),
                      initialStartDate: startThisMonth(),
                      initialEndDate: endThisDay(),
                      initialIsIncome: false,
                    ),
                    child: const TransactionsHistoryScreen(isIncome: false),
                  ),
                  routes: [
                    GoRoute(
                      path: 'transaction/:transactionId',
                      builder: (context, state) {
                        final id = int.parse(
                          state.pathParameters['transactionId']!,
                        );
                        final bloc = state.extra as TransactionHistoryBloc?;
                        if (bloc == null) {
                          throw Exception(
                            'TransactionHistoryBloc must be passed as extra',
                          );
                        }
                        return BlocProvider.value(
                          value: bloc,
                          child: TransactionEditScreen(transactionId: id),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'analysis',
                      builder: (context, state) => BlocProvider(
                        create: (_) => TransactionHistoryBloc(
                          getTransactions: UseCaseGetTransactionsByPeriod(
                            context.read<MockedTransactionRepository>(),
                            context.read<MockedCategoryRepository>(),
                          ),
                          initialStartDate: startThisMonth(),
                          initialEndDate: endThisDay(),
                          initialIsIncome: false,
                        ),
                        child: const TransactionsAnalysisScreen(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/incomes',
              builder: (context, state) => BlocProvider(
                create: (_) => TransactionHistoryBloc(
                  getTransactions: UseCaseGetTransactionsByPeriod(
                    context.read<MockedTransactionRepository>(),
                    context.read<MockedCategoryRepository>(),
                  ),
                  initialStartDate: startThisDay(),
                  initialEndDate: endThisDay(),
                  initialIsIncome: true,
                ),
                child: const TransactionsScreen(isIncome: true),
              ),
              routes: [
                GoRoute(
                  path: 'transaction/:transactionId',
                  builder: (context, state) {
                    final id = int.parse(
                      state.pathParameters['transactionId']!,
                    );
                    final bloc = state.extra as TransactionHistoryBloc?;
                    if (bloc == null) {
                      throw Exception(
                        'TransactionHistoryBloc must be passed as extra',
                      );
                    }
                    return BlocProvider.value(
                      value: bloc,
                      child: TransactionEditScreen(transactionId: id),
                    );
                  },
                ),
                GoRoute(
                  path: 'history',
                  builder: (context, state) => BlocProvider(
                    create: (_) => TransactionHistoryBloc(
                      getTransactions: UseCaseGetTransactionsByPeriod(
                        context.read<MockedTransactionRepository>(),
                        context.read<MockedCategoryRepository>(),
                      ),
                      initialStartDate: startThisMonth(),
                      initialEndDate: endThisDay(),
                      initialIsIncome: true,
                    ),
                    child: const TransactionsHistoryScreen(isIncome: true),
                  ),
                  routes: [
                    GoRoute(
                      path: 'transaction/:transactionId',
                      builder: (context, state) {
                        final id = int.parse(
                          state.pathParameters['transactionId']!,
                        );
                        final bloc = state.extra as TransactionHistoryBloc?;
                        if (bloc == null) {
                          throw Exception(
                            'TransactionHistoryBloc must be passed as extra',
                          );
                        }
                        return BlocProvider.value(
                          value: bloc,
                          child: TransactionEditScreen(transactionId: id),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'analysis',
                      builder: (context, state) => BlocProvider(
                        create: (_) => TransactionHistoryBloc(
                          getTransactions: UseCaseGetTransactionsByPeriod(
                            context.read<MockedTransactionRepository>(),
                            context.read<MockedCategoryRepository>(),
                          ),
                          initialStartDate: startThisMonth(),
                          initialEndDate: endThisDay(),
                          initialIsIncome: true,
                        ),
                        child: const TransactionsAnalysisScreen(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => const AccountScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const AccountEditNameScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/items',
              builder: (context, state) => const ItemsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
