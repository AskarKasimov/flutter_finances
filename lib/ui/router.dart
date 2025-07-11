import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';
import 'package:flutter_finances/domain/usecases/create_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/delete_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_accounts_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_categories_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transaction_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_transaction_usecase.dart';
import 'package:flutter_finances/gen/assets.gen.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_bloc.dart';
import 'package:flutter_finances/ui/blocs/transaction_creation/transaction_creation_event.dart';
import 'package:flutter_finances/ui/blocs/transactions/transactions_history_bloc.dart';
import 'package:flutter_finances/ui/tabs/account/account_edit_name_screen.dart';
import 'package:flutter_finances/ui/tabs/account/account_screen.dart';
import 'package:flutter_finances/ui/tabs/items_screen.dart';
import 'package:flutter_finances/ui/tabs/settings_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/analysis/transactions_analysis.dart';
import 'package:flutter_finances/ui/tabs/transactions/transaction_edit_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_history_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_screen.dart';
import 'package:flutter_finances/utils/date_utils.dart';
import 'package:go_router/go_router.dart';

ColorFilter? _navIconColor(BuildContext context, bool isSelected) {
  return isSelected
      ? ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn)
      : null;
}

TransactionHistoryBloc _makeTransactionHistoryBloc({
  required BuildContext context,
  required DateTime initialStartDate,
  required DateTime initialEndDate,
  required bool? isIncome,
}) {
  return TransactionHistoryBloc(
    getTransactions: GetTransactionsByPeriodUseCase(
      transactionRepository: context.read<TransactionRepository>(),
      categoryRepository: context.read<CategoryRepository>(),
    ),
    initialStartDate: initialStartDate,
    initialEndDate: initialEndDate,
    initialIsIncome: isIncome,
  );
}

TransactionCreationBloc _makeTransactionCreationBloc({
  required BuildContext context,
}) {
  return TransactionCreationBloc(
    deleteTransactionUseCase: context.read<DeleteTransactionUseCase>(),
    getAllAccountsUseCase: context.read<GetAllAccountsUseCase>(),
    getTransactionByIdUseCase: context.read<GetTransactionByIdUseCase>(),
    getAllCategoriesUseCase: context.read<GetAllCategoriesUseCase>(),
    updateTransactionUseCase: context.read<UpdateTransactionUseCase>(),
    createTransactionUseCase: context.read<CreateTransactionUseCase>(),
  );
}

GoRouter createRouter(BuildContext context) => GoRouter(
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
                create: (_) => _makeTransactionHistoryBloc(
                  context: context,
                  initialStartDate: startThisDay(),
                  initialEndDate: endThisDay(),
                  isIncome: false,
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
                    return BlocProvider(
                      create: (_) =>
                          _makeTransactionCreationBloc(context: context)
                            ..add(InitializeForEditing(transactionId: id)),
                      child: TransactionEditScreen(transactionId: id),
                    );
                  },
                ),
                GoRoute(
                  path: 'history',
                  builder: (context, state) => BlocProvider(
                    create: (_) => _makeTransactionHistoryBloc(
                      context: context,
                      initialStartDate: startThisMonth(),
                      initialEndDate: endThisDay(),
                      isIncome: false,
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
                        return BlocProvider(
                          create: (_) =>
                              _makeTransactionCreationBloc(context: context)
                                ..add(InitializeForEditing(transactionId: id)),
                          child: TransactionEditScreen(transactionId: id),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'analysis',
                      builder: (context, state) => BlocProvider(
                        create: (_) => _makeTransactionHistoryBloc(
                          context: context,
                          initialStartDate: startThisMonth(),
                          initialEndDate: endThisDay(),
                          isIncome: false,
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
                create: (_) => _makeTransactionHistoryBloc(
                  context: context,
                  initialStartDate: startThisDay(),
                  initialEndDate: endThisDay(),
                  isIncome: true,
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
                    return BlocProvider(
                      create: (_) =>
                          _makeTransactionCreationBloc(context: context)
                            ..add(InitializeForEditing(transactionId: id)),
                      child: TransactionEditScreen(transactionId: id),
                    );
                  },
                ),
                GoRoute(
                  path: 'history',
                  builder: (context, state) => BlocProvider(
                    create: (_) => _makeTransactionHistoryBloc(
                      context: context,
                      initialStartDate: startThisMonth(),
                      initialEndDate: endThisDay(),
                      isIncome: true,
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
                        return BlocProvider(
                          create: (_) =>
                              _makeTransactionCreationBloc(context: context)
                                ..add(InitializeForEditing(transactionId: id)),
                          child: TransactionEditScreen(transactionId: id),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'analysis',
                      builder: (context, state) => BlocProvider(
                        create: (_) => _makeTransactionHistoryBloc(
                          context: context,
                          initialStartDate: startThisMonth(),
                          initialEndDate: endThisDay(),
                          isIncome: true,
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
              builder: (context, state) => BlocProvider(
                create: (_) => _makeTransactionHistoryBloc(
                  context: context,
                  initialStartDate: startThisMonth(),
                  initialEndDate: endThisDay(),
                  isIncome: null,
                ),
                child: const AccountScreen(),
              ),
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
