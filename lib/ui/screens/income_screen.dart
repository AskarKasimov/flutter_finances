import 'package:flutter/material.dart';
import 'package:flutter_finances/ui/navigation/tab.dart';

class IncomeScreen extends StatelessWidget implements TabScreen {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Доходы'));
  }

  @override
  IconData get tabIcon => Icons.trending_up_outlined;

  @override
  String get tabLabel => "Доходы";
}
