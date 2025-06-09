import 'package:flutter/material.dart';

import '../navigation/tab.dart';

class ItemsScreen extends StatelessWidget implements TabScreen {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Статьи'));
  }

  @override
  IconData get tabIcon => Icons.notes_outlined;

  @override
  String get tabLabel => "Статьи";
}
