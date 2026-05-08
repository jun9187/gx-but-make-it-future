import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/cash_flow/presentation/cash_flow_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/flowguard/presentation/flowguard_screen.dart';
import 'features/future_flow/presentation/future_flow_screen.dart';
import 'features/future_home/presentation/future_home_screen.dart';
import 'features/shell/presentation/app_shell.dart';
import 'features/shop/presentation/shop_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: DashboardScreen.routePath,
    routes: [
      GoRoute(
        path: FutureHomeScreen.routePath,
        name: FutureHomeScreen.routeName,
        builder: (context, state) => const FutureHomeScreen(),
      ),
      GoRoute(
        path: ShopScreen.routePath,
        name: ShopScreen.routeName,
        builder: (context, state) => const ShopScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: DashboardScreen.routePath,
                name: DashboardScreen.routeName,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: FutureFlowScreen.routePath,
                name: FutureFlowScreen.routeName,
                builder: (context, state) => const FutureFlowScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: CashFlowScreen.routePath,
                name: CashFlowScreen.routeName,
                builder: (context, state) => const CashFlowScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: FlowguardScreen.routePath,
                name: FlowguardScreen.routeName,
                builder: (context, state) => const FlowguardScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class FutureFlowApp extends ConsumerWidget {
  const FutureFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'FutureFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
