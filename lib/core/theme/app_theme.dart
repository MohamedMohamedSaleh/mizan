import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';
import 'theme_extensions/theme_extensions.dart';

/// Mizan theme factory — provides [ThemeData] for light and dark modes.
///
/// Both themes share the same typography and component shapes, but use
/// different color tokens from [AppColors].
abstract final class AppTheme {
  // ═══════════════════════════ LIGHT ═══════════════════════════════
  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      tertiary: AppColors.lightAccent,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightInputFill,
      error: AppColors.error,
      onPrimary: AppColors.lightTextOnPrimary,
      onSecondary: AppColors.lightTextOnPrimary,
      onSurface: AppColors.lightTextPrimary,
      onError: Colors.white,
      outline: AppColors.lightBorder,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldColor: AppColors.lightScaffold,
      cardColor: AppColors.lightCard,
      dividerColor: AppColors.lightDivider,
      borderColor: AppColors.lightBorder,
      inputFillColor: AppColors.lightInputFill,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      appColorsExtension: AppColorsExtension.light,
    );
  }

  // ═══════════════════════════ DARK ════════════════════════════════
  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      tertiary: AppColors.darkAccent,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkInputFill,
      error: AppColors.error,
      onPrimary: AppColors.darkTextOnPrimary,
      onSecondary: AppColors.darkTextOnPrimary,
      onSurface: AppColors.darkTextPrimary,
      onError: Colors.white,
      outline: AppColors.darkBorder,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldColor: AppColors.darkScaffold,
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkDivider,
      borderColor: AppColors.darkBorder,
      inputFillColor: AppColors.darkInputFill,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      appColorsExtension: AppColorsExtension.dark,
    );
  }

  // ═══════════════════════ SHARED BUILDER ══════════════════════════
  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required Color scaffoldColor,
    required Color cardColor,
    required Color dividerColor,
    required Color borderColor,
    required Color inputFillColor,
    required Color textPrimary,
    required Color textSecondary,
    required AppColorsExtension appColorsExtension,
  }) {
    final isLight = brightness == Brightness.light;
    final textTheme = AppTextStyles.textTheme.apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: textTheme,
      dividerColor: dividerColor,

      // ──────────────── Extensions ────────────────
      extensions: [appColorsExtension],

      // ──────────────── AppBar ────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        backgroundColor: scaffoldColor,
        foregroundColor: textPrimary,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: textPrimary),
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: textPrimary, size: 24),
      ),

      // ──────────────── Card ─────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusBase,
          side: BorderSide(color: borderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ──────────────── Elevated Button ──────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusBase,
          ),
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      // ──────────────── Outlined Button ──────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusBase,
          ),
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      // ──────────────── Text Button ──────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // ──────────────── FAB ──────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
      ),

      // ──────────────── Input / TextField ────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusBase,
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusBase,
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusBase,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusBase,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusBase,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),

      // ──────────────── Chip ─────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: inputFillColor,
        selectedColor: colorScheme.primary.withValues(alpha: 0.15),
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusFull,
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ──────────────── Bottom Sheet ─────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.topXl,
        ),
        showDragHandle: true,
        dragHandleColor: borderColor,
      ),

      // ──────────────── Dialog ───────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
      ),

      // ──────────────── Divider ──────────────────
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      // ──────────────── Bottom Nav Bar ───────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isLight ? AppColors.lightNavBar : AppColors.darkNavBar,
        selectedItemColor: isLight
            ? AppColors.lightNavBarSelected
            : AppColors.darkNavBarSelected,
        unselectedItemColor: isLight
            ? AppColors.lightNavBarUnselected
            : AppColors.darkNavBarUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTextStyles.labelSmall,
        unselectedLabelStyle: AppTextStyles.labelSmall,
      ),

      // ──────────────── Navigation Rail ──────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: cardColor,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: textSecondary),
        selectedLabelTextStyle:
            AppTextStyles.labelSmall.copyWith(color: colorScheme.primary),
        unselectedLabelTextStyle:
            AppTextStyles.labelSmall.copyWith(color: textSecondary),
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
      ),

      // ──────────────── Tab Bar ──────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: textSecondary,
        labelStyle: AppTextStyles.labelLarge,
        unselectedLabelStyle: AppTextStyles.labelLarge,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 2.5),
          borderRadius: AppRadius.borderRadiusFull,
        ),
      ),

      // ──────────────── Snack Bar ────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isLight ? AppColors.lightTextPrimary : AppColors.darkCard,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: isLight ? Colors.white : AppColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusBase,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ──────────────── Tooltip ──────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: textPrimary,
          borderRadius: AppRadius.borderRadiusSm,
        ),
        textStyle: AppTextStyles.bodySmall.copyWith(
          color: isLight ? Colors.white : AppColors.darkBackground,
        ),
      ),

      // ──────────────── Progress Indicator ───────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: borderColor,
        circularTrackColor: borderColor,
      ),
    );
  }
}
