import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'dashboard_nav_item.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    super.key,
    required this.items,
    required this.currentLocation,
    required this.onItemSelected,
    required this.onLogout,
    this.isLogoutLoading = false,
  });

  final List<DashboardNavItem> items;
  final String currentLocation;
  final ValueChanged<DashboardNavItem> onItemSelected;
  final VoidCallback onLogout;
  final bool isLogoutLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: context.colors.card,
        border: BorderDirectional(
          start: BorderSide(color: context.colors.border),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SidebarHeader(),
              AppSpacing.gapH24,
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _SidebarTile(
                      item: item,
                      isSelected: _isSelected(item.routePath),
                      onTap: () => onItemSelected(item),
                    );
                  },
                  separatorBuilder: (_, __) => AppSpacing.gapH8,
                  itemCount: items.length,
                ),
              ),
              const Divider(),
              _SidebarTile(
                item: DashboardNavItem(
                  title: LocaleKeys.authLogout.tr(),
                  subtitle: LocaleKeys.appName.tr(),
                  icon: Icons.logout,
                  routePath: '',
                ),
                isSelected: false,
                onTap: isLogoutLoading ? null : onLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSelected(String routePath) {
    if (routePath == '/dashboard') return currentLocation == routePath;
    return currentLocation == routePath || currentLocation.startsWith('$routePath/');
  }
}

class DashboardDrawerMenu extends StatelessWidget {
  const DashboardDrawerMenu({
    super.key,
    required this.items,
    required this.currentLocation,
    required this.onItemSelected,
    required this.onLogout,
    this.isLogoutLoading = false,
  });

  final List<DashboardNavItem> items;
  final String currentLocation;
  final ValueChanged<DashboardNavItem> onItemSelected;
  final VoidCallback onLogout;
  final bool isLogoutLoading;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DashboardSidebar(
        items: items,
        currentLocation: currentLocation,
        onItemSelected: onItemSelected,
        onLogout: onLogout,
        isLogoutLoading: isLogoutLoading,
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: context.colors.primary,
            borderRadius: AppRadius.borderRadiusBase,
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: context.colors.textOnPrimary,
          ),
        ),
        AppSpacing.gapW12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.appName.tr(),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                LocaleKeys.appTagline.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final DashboardNavItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? context.colors.primary : context.colors.textPrimary;
    return Material(
      color: isSelected
          ? context.colors.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: AppRadius.borderRadiusBase,
      child: InkWell(
        borderRadius: AppRadius.borderRadiusBase,
        onTap: onTap,
        mouseCursor: onTap == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(item.icon, color: foreground),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: foreground,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_left,
                color: isSelected ? context.colors.primary : context.colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
