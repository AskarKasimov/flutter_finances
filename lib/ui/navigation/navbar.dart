import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/navigation/tab.dart';

import '../screens/account_screen.dart';
import '../screens/expenses_screen.dart';
import '../screens/income_screen.dart';
import '../screens/items_screen.dart';
import '../screens/settings_screen.dart';

class MainTabBar extends StatefulWidget {
  const MainTabBar({super.key});

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  final List<TabScreen> _screens = const [
    ExpensesScreen(),
    IncomeScreen(),
    AccountScreen(),
    ItemsScreen(),
    SettingsScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _screens[_currentIndex].appBar,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items:
            _screens
                .map(
                  (screen) => BottomNavigationBarItem(
                    icon: Icon(screen.tabIcon),
                    label: screen.tabLabel,
                  ),
                )
                .toList(),
      ),
    );
  }
}
