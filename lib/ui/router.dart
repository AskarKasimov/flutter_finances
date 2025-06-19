import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/tabs/account_screen.dart';
import 'package:flutter_finances/ui/tabs/items_screen.dart';
import 'package:flutter_finances/ui/tabs/settings_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_history_screen.dart';
import 'package:flutter_finances/ui/tabs/transactions/transactions_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/expenses',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) {
        return Scaffold(
          body: shell,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: shell.currentIndex,
            onTap: (index) {
              if (index == shell.currentIndex) {
                shell.goBranch(index, initialLocation: true);
              } else {
                shell.goBranch(index);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_down_outlined),
                label: 'Расходы',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up_outlined),
                label: 'Доходы',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate_outlined),
                label: 'Счета',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notes_outlined),
                label: 'Статьи',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
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
                  (context, state) =>
                      const TransactionsScreen(type: TransactionType.expense),
              routes: [
                GoRoute(
                  path: 'history',
                  builder:
                      (context, state) => const TransactionsHistoryScreen(
                        type: TransactionType.expense,
                      ),
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
                  (context, state) =>
                      const TransactionsScreen(type: TransactionType.income),
              routes: [
                GoRoute(
                  path: 'history',
                  builder:
                      (context, state) => const TransactionsHistoryScreen(
                        type: TransactionType.income,
                      ),
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
