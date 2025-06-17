import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/navigation/tab_screen_interface.dart';

class ExpensesScreen extends StatelessWidget implements TabScreen {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('экран с тратами'));
  }

  @override
  IconData get tabIcon => Icons.trending_down_outlined;

  @override
  String get tabLabel => 'Расходы';

  @override
  AppBar get appBar =>
      AppBar(title: const Text('Расходы сегодня'), centerTitle: true);
}
