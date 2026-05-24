import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/expense_enums.dart';

class ExpenseStatusBadge extends StatelessWidget {
  const ExpenseStatusBadge({super.key, required this.status});

  final ExpenseStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ExpenseStatus.draft => (
          LocaleKeys.expensesStatusDraft.tr(),
          context.colors.warning,
        ),
      ExpenseStatus.saved => (
          LocaleKeys.expensesStatusSaved.tr(),
          context.colors.success,
        ),
      ExpenseStatus.voided => (
          LocaleKeys.expensesStatusVoided.tr(),
          context.colors.error,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
