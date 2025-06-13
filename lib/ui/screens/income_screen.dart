import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/navigation/tab.dart';

class IncomeScreen extends StatelessWidget implements TabScreen {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('экран с доходами'));
  }

  @override
  IconData get tabIcon => Icons.trending_up_outlined;

  @override
  String get tabLabel => 'Доходы';

  @override
  AppBar get appBar =>
      AppBar(title: const Text('Доходы сегодня'), centerTitle: true);
}
