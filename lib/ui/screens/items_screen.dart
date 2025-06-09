import 'package:flutter/material.dart';

import '../navigation/tab.dart';

class ItemsScreen extends StatelessWidget implements TabScreen {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('экран со статьями'));
  }

  @override
  IconData get tabIcon => Icons.notes_outlined;

  @override
  String get tabLabel => "Статьи";

  @override
  AppBar get appBar =>
      AppBar(title: const Text('Мои статьи'), centerTitle: true);
}
