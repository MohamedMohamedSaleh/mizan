import 'package:flutter/material.dart';

/// Mizan brand color palette — fintech SaaS style.
///
/// Access via [AppColors] static constants or through
/// the [AppColorsExtension] theme extension for theme-aware usage.
abstract final class AppColors {
  // ──────────────────────────── Brand ────────────────────────────
  static const Color brand = Color(0xFF0F766E);
  static const Color brandLight = Color(0xFF14B8A6);
  static const Color brandDark = Color(0xFF0D6D66);

  // ─────────────────────── Light Theme ───────────────────────────
  static const Color lightPrimary = Color(0xFF0F766E);
  static const Color lightSecondary = Color(0xFF14B8A6);
  static const Color lightAccent = Color(0xFF22C55E);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);
  static const Color lightTextOnPrimary = Color(0xFFFFFFFF);
  static const Color lightInputFill = Color(0xFFF1F5F9);
  static const Color lightScaffold = Color(0xFFF8FAFC);
  static const Color lightNavBar = Color(0xFFFFFFFF);
  static const Color lightNavBarSelected = Color(0xFF0F766E);
  static const Color lightNavBarUnselected = Color(0xFF94A3B8);
  static const Color lightShimmerBase = Color(0xFFE2E8F0);
  static const Color lightShimmerHighlight = Color(0xFFF1F5F9);

  // ─────────────────────── Dark Theme ────────────────────────────
  static const Color darkPrimary = Color(0xFF2DD4BF);
  static const Color darkSecondary = Color(0xFF14B8A6);
  static const Color darkAccent = Color(0xFF22C55E);
  static const Color darkBackground = Color(0xFF0B1120);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);
  static const Color darkTextOnPrimary = Color(0xFF0B1120);
  static const Color darkInputFill = Color(0xFF1E293B);
  static const Color darkScaffold = Color(0xFF0B1120);
  static const Color darkNavBar = Color(0xFF111827);
  static const Color darkNavBarSelected = Color(0xFF2DD4BF);
  static const Color darkNavBarUnselected = Color(0xFF64748B);
  static const Color darkShimmerBase = Color(0xFF1E293B);
  static const Color darkShimmerHighlight = Color(0xFF334155);

  // ─────────────────────── Semantic ──────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successDark = Color(0xFF166534);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFF92400E);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFF991B1B);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF1E40AF);

  // ─────────────────────── Accounting ────────────────────────────
  static const Color debit = Color(0xFFEF4444);
  static const Color credit = Color(0xFF22C55E);
  static const Color balanced = Color(0xFF0F766E);
  static const Color unbalanced = Color(0xFFEF4444);

  // ─────────────────────── Charts ────────────────────────────────
  static const List<Color> chartPalette = [
    Color(0xFF0F766E),
    Color(0xFF14B8A6),
    Color(0xFF22C55E),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
  ];
}
