import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
  });

  final String title;
  final double amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.responsive(mobile: 220, tablet: null),
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          AppSpacing.gapH12,
          Text(
            '${NumberFormat.currency(symbol: '', decimalDigits: 2).format(amount)} $currency',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
