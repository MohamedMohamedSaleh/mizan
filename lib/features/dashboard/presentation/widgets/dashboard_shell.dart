import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'dashboard_nav_item.dart';
import 'dashboard_sidebar.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final items = _navItems();
    final currentLocation = GoRouterState.of(context).uri.path;
    final isWide = context.width >= 900;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          AppToast.success(context, LocaleKeys.authLogout.tr());
        } else if (state is AuthError) {
          AppToast.error(context, state.message);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final isLogoutLoading = authState is AuthLoading;
          return Scaffold(
            appBar: isWide
                ? null
                : AppBar(
                    title: Text(_titleForLocation(items, currentLocation)),
                    actions: [
                      Builder(
                        builder: (buttonContext) => IconButton(
                          tooltip: LocaleKeys.navSettings.tr(),
                          onPressed: () =>
                              Scaffold.of(buttonContext).openEndDrawer(),
                          icon: const Icon(Icons.menu),
                        ),
                      ),
                    ],
                  ),
            endDrawer: isWide
                ? null
                : DashboardDrawerMenu(
                    items: items,
                    currentLocation: currentLocation,
                    isLogoutLoading: isLogoutLoading,
                    onItemSelected: (item) {
                      Navigator.of(context).pop();
                      context.go(item.routePath);
                    },
                    onLogout: () => context.read<AuthCubit>().logout(),
                  ),
            body: Row(
              textDirection: ui.TextDirection.ltr,
              children: [
                Expanded(child: child),
                if (isWide)
                  DashboardSidebar(
                    items: items,
                    currentLocation: currentLocation,
                    isLogoutLoading: isLogoutLoading,
                    onItemSelected: (item) => context.go(item.routePath),
                    onLogout: () => context.read<AuthCubit>().logout(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DashboardNavItem> _navItems() {
    return [
      DashboardNavItem(
        title: LocaleKeys.navDashboard.tr(),
        subtitle: LocaleKeys.dashboardOverview.tr(),
        icon: Icons.dashboard_customize_outlined,
        routePath: RoutePaths.dashboard,
      ),
      DashboardNavItem(
        title: LocaleKeys.navExpenses.tr(),
        subtitle: LocaleKeys.reportsExpenseReport.tr(),
        icon: Icons.receipt_long_outlined,
        routePath: RoutePaths.expenses,
      ),
      DashboardNavItem(
        title: LocaleKeys.navReports.tr(),
        subtitle: LocaleKeys.reportsGenerate.tr(),
        icon: Icons.assessment_outlined,
        routePath: RoutePaths.reports,
      ),
      DashboardNavItem(
        title: LocaleKeys.navJournalEntries.tr(),
        subtitle: LocaleKeys.navGeneralAccounting.tr(),
        icon: Icons.account_balance_outlined,
        routePath: RoutePaths.journalEntries,
      ),
      DashboardNavItem(
        title: LocaleKeys.navAccounts.tr(),
        subtitle: LocaleKeys.navFinance.tr(),
        icon: Icons.account_tree_outlined,
        routePath: RoutePaths.accounts,
      ),
      DashboardNavItem(
        title: LocaleKeys.navSettings.tr(),
        subtitle: LocaleKeys.settingsTitle.tr(),
        icon: Icons.settings_outlined,
        routePath: RoutePaths.settings,
      ),
    ];
  }

  String _titleForLocation(List<DashboardNavItem> items, String location) {
    for (final item in items) {
      if (location == item.routePath || location.startsWith('${item.routePath}/')) {
        return item.title;
      }
    }
    return LocaleKeys.appName.tr();
  }
}
