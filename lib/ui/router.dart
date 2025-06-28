import 'package:flutter/material.dart';
import 'package:flutter_finances/gen/assets.gen.dart';
import 'package:flutter_finances/ui/tabs/account/account_edit_name_screen.dart';
import 'package:flutter_finances/ui/tabs/account/account_screen.dart';
import 'package:flutter_finances/ui/tabs/items_screen.dart';
import 'package:flutter_finances/ui/tabs/settings_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_history_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_screen.dart';
import 'package:go_router/go_router.dart';

ColorFilter? _navIconColor(BuildContext context, bool isSelected) {
  return isSelected
      ? ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn)
      : null;
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
              builder:
                  (context, state) => const TransactionsScreen(isIncome: false),
              routes: [
                GoRoute(
                  path: 'history',
                  builder:
                      (context, state) =>
                          const TransactionsHistoryScreen(isIncome: false),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/income',
              builder:
                  (context, state) => const TransactionsScreen(isIncome: true),
              routes: [
                GoRoute(
                  path: 'history',
                  builder:
                      (context, state) =>
                          const TransactionsHistoryScreen(isIncome: true),
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
