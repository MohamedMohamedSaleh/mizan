import 'package:flutter/material.dart';

import '../app_colors.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnPrimary,
    required this.inputFill,
    required this.scaffold,
    required this.navBar,
    required this.navBarSelected,
    required this.navBarUnselected,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.infoLight,
    required this.debit,
    required this.credit,
    required this.balanced,
    required this.unbalanced,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color card;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnPrimary;
  final Color inputFill;
  final Color scaffold;
  final Color navBar;
  final Color navBarSelected;
  final Color navBarUnselected;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color error;
  final Color errorLight;
  final Color info;
  final Color infoLight;
  final Color debit;
  final Color credit;
  final Color balanced;
  final Color unbalanced;

  static const light = AppColorsExtension(
    primary: AppColors.lightPrimary,
    secondary: AppColors.lightSecondary,
    accent: AppColors.lightAccent,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    card: AppColors.lightCard,
    border: AppColors.lightBorder,
    divider: AppColors.lightDivider,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textTertiary: AppColors.lightTextTertiary,
    textOnPrimary: AppColors.lightTextOnPrimary,
    inputFill: AppColors.lightInputFill,
    scaffold: AppColors.lightScaffold,
    navBar: AppColors.lightNavBar,
    navBarSelected: AppColors.lightNavBarSelected,
    navBarUnselected: AppColors.lightNavBarUnselected,
    shimmerBase: AppColors.lightShimmerBase,
    shimmerHighlight: AppColors.lightShimmerHighlight,
    success: AppColors.success,
    successLight: AppColors.successLight,
    warning: AppColors.warning,
    warningLight: AppColors.warningLight,
    error: AppColors.error,
    errorLight: AppColors.errorLight,
    info: AppColors.info,
    infoLight: AppColors.infoLight,
    debit: AppColors.debit,
    credit: AppColors.credit,
    balanced: AppColors.balanced,
    unbalanced: AppColors.unbalanced,
  );

  static const dark = AppColorsExtension(
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkSecondary,
    accent: AppColors.darkAccent,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    card: AppColors.darkCard,
    border: AppColors.darkBorder,
    divider: AppColors.darkDivider,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
    textOnPrimary: AppColors.darkTextOnPrimary,
    inputFill: AppColors.darkInputFill,
    scaffold: AppColors.darkScaffold,
    navBar: AppColors.darkNavBar,
    navBarSelected: AppColors.darkNavBarSelected,
    navBarUnselected: AppColors.darkNavBarUnselected,
    shimmerBase: AppColors.darkShimmerBase,
    shimmerHighlight: AppColors.darkShimmerHighlight,
    success: AppColors.success,
    successLight: AppColors.successDark,
    warning: AppColors.warning,
    warningLight: AppColors.warningDark,
    error: AppColors.error,
    errorLight: AppColors.errorDark,
    info: AppColors.info,
    infoLight: AppColors.infoDark,
    debit: AppColors.debit,
    credit: AppColors.credit,
    balanced: AppColors.balanced,
    unbalanced: AppColors.unbalanced,
  );

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary, Color? secondary, Color? accent,
    Color? background, Color? surface, Color? card,
    Color? border, Color? divider,
    Color? textPrimary, Color? textSecondary, Color? textTertiary,
    Color? textOnPrimary, Color? inputFill, Color? scaffold,
    Color? navBar, Color? navBarSelected, Color? navBarUnselected,
    Color? shimmerBase, Color? shimmerHighlight,
    Color? success, Color? successLight,
    Color? warning, Color? warningLight,
    Color? error, Color? errorLight,
    Color? info, Color? infoLight,
    Color? debit, Color? credit, Color? balanced, Color? unbalanced,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      inputFill: inputFill ?? this.inputFill,
      scaffold: scaffold ?? this.scaffold,
      navBar: navBar ?? this.navBar,
      navBarSelected: navBarSelected ?? this.navBarSelected,
      navBarUnselected: navBarUnselected ?? this.navBarUnselected,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      info: info ?? this.info,
      infoLight: infoLight ?? this.infoLight,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      balanced: balanced ?? this.balanced,
      unbalanced: unbalanced ?? this.unbalanced,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other, double t,
  ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      navBarSelected: Color.lerp(navBarSelected, other.navBarSelected, t)!,
      navBarUnselected: Color.lerp(navBarUnselected, other.navBarUnselected, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      debit: Color.lerp(debit, other.debit, t)!,
      credit: Color.lerp(credit, other.credit, t)!,
      balanced: Color.lerp(balanced, other.balanced, t)!,
      unbalanced: Color.lerp(unbalanced, other.unbalanced, t)!,
    );
  }
}
