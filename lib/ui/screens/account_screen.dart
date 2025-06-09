import 'package:flutter/material.dart';

import '../navigation/tab.dart';

class AccountScreen extends StatelessWidget implements TabScreen {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('экран со счетом'));
  }

  @override
  IconData get tabIcon => Icons.calculate_outlined;

  @override
  String get tabLabel => 'Счет';

  @override
  AppBar get appBar => AppBar(title: const Text('Мой счет'), centerTitle: true);
}
