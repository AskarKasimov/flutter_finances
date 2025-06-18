import 'package:flutter_finances/ui/navigation/root_screen.dart';
import 'package:go_router/go_router.dart';

import 'navigation/root_tabs.dart';

final GoRouter router = GoRouter(
  initialLocation: rootTabs[0].routePath,
  routes: [
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              RootScreen(navigationShell: navigationShell),
      branches:
          rootTabs.map((tab) {
            return StatefulShellBranch(
              routes: [
                GoRoute(path: tab.routePath, builder: (context, state) => tab),
              ],
            );
          }).toList(),
    ),
  ],
);
