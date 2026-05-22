import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Reusable text field styled for auth screens.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.autofillHints,
    this.textDirection,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.colors.textPrimary,
              ),
        ),
        AppSpacing.gapH8,
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          autofillHints: autofillHints,
          textDirection: textDirection,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.colors.textPrimary,
              ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: context.colors.textSecondary)
                : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Primary call-to-action button for auth screens.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: context.colors.textOnPrimary,
                ),
              )
            : Text(label),
      ),
    );
  }
}

/// Card-like container for auth forms — adapts to screen size.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final maxWidth = context.responsive(
      mobile: double.infinity,
      tablet: 460.0,
      desktop: 480.0,
    );

    return Center(
      child: Container(
        width: maxWidth,
        margin: context.responsive(
          mobile: AppSpacing.paddingHBase,
          tablet: EdgeInsets.zero,
        ),
        padding: context.responsive(
          mobile: AppSpacing.paddingAllLg,
          tablet: AppSpacing.paddingAllXl,
          desktop: AppSpacing.paddingAllXxl,
        ),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: context.isMobile
              ? AppRadius.borderRadiusBase
              : AppRadius.borderRadiusLg,
          border: context.isMobile
              ? null
              : Border.all(color: context.colors.border),
        ),
        child: child,
      ),
    );
  }
}
