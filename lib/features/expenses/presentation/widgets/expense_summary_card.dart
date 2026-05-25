import 'dart:ui' as ui;
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
    required this.icon,
    this.endPadding = 14,
  });

  final String title;
  final double amount;
  final String currency;
  final IconData icon;
  final double endPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.responsive(mobile: 220, tablet: null),
      margin: EdgeInsetsDirectional.only(end: endPadding),
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: AppRadius.borderRadiusBase,
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: context.colors.primary),
              ),
            ],
          ),
          AppSpacing.gapH12,
          Text(
            title,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          AppSpacing.gapH12,
          Text(
            '${NumberFormat.currency(symbol: '', decimalDigits: 2).format(amount)} $currency',
            textDirection: ui.TextDirection.ltr,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
