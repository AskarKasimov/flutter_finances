import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/navigation/tab.dart';

class ExpensesScreen extends StatelessWidget implements TabScreen {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('экран с тратами'));
  }

  @override
  IconData get tabIcon => Icons.trending_down_outlined;

  @override
  String get tabLabel => "Расходы";
}
