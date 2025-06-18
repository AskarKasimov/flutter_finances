import '../tabs/account_screen.dart';
import '../tabs/items_screen.dart';
import '../tabs/settings_screen.dart';
import '../tabs/transactions/transactions_screen.dart';
import 'tab_screen_interface.dart';

List<TabScreen> rootTabs = [
  TransactionsScreen(type: TransactionType.expense),
  TransactionsScreen(type: TransactionType.income),
  const AccountScreen(),
  const ItemsScreen(),
  const SettingsScreen(),
];
