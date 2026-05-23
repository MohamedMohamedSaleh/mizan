import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = <_DashboardModule>[
      _DashboardModule(
        title: LocaleKeys.navFinance.tr(),
        icon: Icons.account_balance_wallet_outlined,
      ),
      _DashboardModule(
        title: LocaleKeys.navGeneralAccounting.tr(),
        icon: Icons.calculate_outlined,
      ),
      _DashboardModule(
        title: LocaleKeys.navReports.tr(),
        icon: Icons.assessment_outlined,
      ),
      _DashboardModule(
        title: LocaleKeys.navSettings.tr(),
        icon: Icons.settings_outlined,
      ),
    ];

    final crossAxisCount = context.responsive(mobile: 1, tablet: 2, desktop: 4);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.appName.tr()),
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return TextButton.icon(
                onPressed: isLoading ? null : () => context.read<AuthCubit>().logout(),
                icon: const Icon(Icons.logout),
                label: Text(LocaleKeys.authLogout.tr()),
              );
            },
          ),
          AppSpacing.gapW8,
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${LocaleKeys.dashboardWelcome.tr()} ${LocaleKeys.appName.tr()}',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapH20,
              Expanded(
                child: GridView.builder(
                  itemCount: modules.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return _ModuleCard(module: module);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module});

  final _DashboardModule module;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: AppSpacing.paddingAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              module.icon,
              size: 32,
              color: context.colors.primary,
            ),
            AppSpacing.gapH16,
            Text(
              module.title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardModule {
  const _DashboardModule({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;
}
