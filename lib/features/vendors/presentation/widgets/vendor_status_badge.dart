import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../utils/vendor_status_utils.dart';

class VendorStatusBadge extends StatelessWidget {
  const VendorStatusBadge({
    super.key,
    required this.status,
  });

  final String? status;

  @override
  Widget build(BuildContext context) {
    final isInactive =
        VendorStatusUtils.normalize(status) == VendorStatusUtils.inactive;
    final foregroundColor =
        isInactive ? context.colors.error : context.colors.success;
    final label = VendorStatusUtils.label(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: foregroundColor.withValues(alpha: 0.10),
        borderRadius: AppRadius.borderRadiusSm,
      ),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
