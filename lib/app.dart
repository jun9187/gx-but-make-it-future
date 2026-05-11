import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auto_save_history/presentation/auto_save_history_screen.dart';
import 'features/cash_flow/presentation/cash_flow_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/flowguard/presentation/flowguard_demo_screens.dart';
import 'features/flowguard/presentation/flowguard_screen.dart';
import 'features/future_flow/presentation/future_flow_screen.dart';
import 'features/future_home/presentation/future_home_screen.dart';
import 'features/home/presentation/gxbank_home_screen.dart';
import 'features/savings_pockets/presentation/savings_pockets_screen.dart';
import 'features/shell/presentation/app_shell.dart';
import 'features/shop/presentation/shop_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: GxBankHomeScreen.routePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(currentPath: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: GxBankHomeScreen.routePath,
            name: GxBankHomeScreen.routeName,
            builder: (context, state) => const GxBankHomeScreen(),
          ),
          GoRoute(
            path: DashboardScreen.routePath,
            name: DashboardScreen.routeName,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: FutureFlowScreen.routePath,
            name: FutureFlowScreen.routeName,
            builder: (context, state) => const FutureFlowScreen(),
          ),
          GoRoute(
            path: CashFlowScreen.routePath,
            name: CashFlowScreen.routeName,
            builder: (context, state) => const CashFlowScreen(),
          ),
          GoRoute(
            path: FlowGuardQrPaymentScreen.routePath,
            name: FlowGuardQrPaymentScreen.routeName,
            builder: (context, state) => const FlowGuardQrPaymentScreen(),
          ),
          GoRoute(
            path: FlowGuardQrConfirmScreen.routePath,
            name: FlowGuardQrConfirmScreen.routeName,
            builder: (context, state) => const FlowGuardQrConfirmScreen(),
          ),
          GoRoute(
            path: FlowGuardPaymentAlertScreen.routePath,
            name: FlowGuardPaymentAlertScreen.routeName,
            builder: (context, state) => const FlowGuardPaymentAlertScreen(),
          ),
          GoRoute(
            path: FlowguardScreen.routePath,
            name: FlowguardScreen.routeName,
            builder: (context, state) => const FlowguardScreen(),
          ),
          GoRoute(
            path: FutureHomeScreen.routePath,
            name: FutureHomeScreen.routeName,
            builder: (context, state) => const FutureHomeScreen(),
          ),
          GoRoute(
            path: SavingsPocketsScreen.routePath,
            name: SavingsPocketsScreen.routeName,
            builder: (context, state) => const SavingsPocketsScreen(),
          ),
          GoRoute(
            path: AutoSaveHistoryScreen.routePath,
            name: AutoSaveHistoryScreen.routeName,
            builder: (context, state) => const AutoSaveHistoryScreen(),
          ),
          GoRoute(
            path: ShopScreen.routePath,
            name: ShopScreen.routeName,
            builder: (context, state) => const ShopScreen(),
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
