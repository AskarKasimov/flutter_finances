import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'root_tabs.dart';

class RootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(index, initialLocation: true);
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = rootTabs[navigationShell.currentIndex];
    return Scaffold(
      appBar: currentTab.appBar,
      body: navigationShell,
      floatingActionButton: currentTab.floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items:
            rootTabs
                .map(
                  (tab) => BottomNavigationBarItem(
                    icon: Icon(tab.tabIcon),
                    label: tab.tabLabel,
                  ),
                )
                .toList(),
      ),
    );
  }
}
