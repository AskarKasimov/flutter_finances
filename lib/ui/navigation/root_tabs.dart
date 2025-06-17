import '../tabs/account_screen.dart';
import '../tabs/expenses_screen.dart';
import '../tabs/income_screen.dart';
import '../tabs/items_screen.dart';
import '../tabs/settings_screen.dart';
import 'tab_screen_interface.dart';

const List<TabScreen> rootTabs = [
  ExpensesScreen(),
  IncomeScreen(),
  AccountScreen(),
  ItemsScreen(),
  SettingsScreen(),
];
