import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: _pagePadding(context),
      children: [
        Container(
          padding: AppSpacing.paddingAllXl,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.primary.withValues(alpha: 0.16),
                context.colors.card,
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: AppRadius.borderRadiusBase,
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.navDashboard.tr(),
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppSpacing.gapH8,
              Text(
                LocaleKeys.appTagline.tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapH16,
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            _DashboardMetric(
              icon: Icons.receipt_long_outlined,
              title: LocaleKeys.navExpenses.tr(),
              description: LocaleKeys.dashboardRecentTransactions.tr(),
            ),
            _DashboardMetric(
              icon: Icons.assessment_outlined,
              title: LocaleKeys.navReports.tr(),
              description: LocaleKeys.reportsGenerate.tr(),
            ),
            _DashboardMetric(
              icon: Icons.account_balance_outlined,
              title: LocaleKeys.navGeneralAccounting.tr(),
              description: LocaleKeys.navJournalEntries.tr(),
            ),
          ],
        ),
      ],
    );
  }
}

class DashboardPlaceholderView extends StatelessWidget {
  const DashboardPlaceholderView({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: _pagePadding(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: AppSpacing.paddingAllXl,
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: AppRadius.borderRadiusBase,
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 44, color: context.colors.primary),
                AppSpacing.gapH16,
                Text(
                  title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.gapH8,
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardMetric extends StatelessWidget {
  const _DashboardMetric({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.responsive(mobile: double.infinity, tablet: 260),
      child: Container(
        padding: AppSpacing.paddingAllLg,
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: AppRadius.borderRadiusBase,
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.colors.primary),
            AppSpacing.gapH12,
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSpacing.gapH4,
            Text(
              description,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

EdgeInsets _pagePadding(BuildContext context) {
  return context.responsive(
    mobile: AppSpacing.pagePaddingMobile,
    tablet: AppSpacing.pagePaddingTablet,
    desktop: AppSpacing.pagePaddingDesktop,
  );
}
