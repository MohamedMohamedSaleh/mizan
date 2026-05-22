import 'package:flutter/material.dart';

/// Consistent spacing tokens used across the entire app.
///
/// Based on a 4-px grid system (4 → 8 → 12 → 16 → 20 → 24 → 32 → 40 → 48 → 64).
abstract final class AppSpacing {
  // ─────────────────────── Raw values ────────────────────────────
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;
  static const double massive = 64;

  // ────────────────── Symmetric EdgeInsets ────────────────────────
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllBase = EdgeInsets.all(base);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingAllXxl = EdgeInsets.all(xxl);

  // ─────────────── Horizontal-only EdgeInsets ────────────────────
  static const EdgeInsets paddingHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHBase = EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets paddingHLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHXl = EdgeInsets.symmetric(horizontal: xl);

  // ─────────────── Vertical-only EdgeInsets ──────────────────────
  static const EdgeInsets paddingVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVBase = EdgeInsets.symmetric(vertical: base);
  static const EdgeInsets paddingVLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVXl = EdgeInsets.symmetric(vertical: xl);

  // ─────────────── Page-level padding ────────────────────────────
  static const EdgeInsets pagePaddingMobile = EdgeInsets.symmetric(
    horizontal: base,
    vertical: sm,
  );
  static const EdgeInsets pagePaddingTablet = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: base,
  );
  static const EdgeInsets pagePaddingDesktop = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: lg,
  );

  // ─────────────── Gaps (for use in Row / Column) ────────────────
  static const SizedBox gapW4 = SizedBox(width: xs);
  static const SizedBox gapW8 = SizedBox(width: sm);
  static const SizedBox gapW12 = SizedBox(width: md);
  static const SizedBox gapW16 = SizedBox(width: base);
  static const SizedBox gapW20 = SizedBox(width: lg);
  static const SizedBox gapW24 = SizedBox(width: xl);
  static const SizedBox gapW32 = SizedBox(width: xxl);

  static const SizedBox gapH4 = SizedBox(height: xs);
  static const SizedBox gapH8 = SizedBox(height: sm);
  static const SizedBox gapH12 = SizedBox(height: md);
  static const SizedBox gapH16 = SizedBox(height: base);
  static const SizedBox gapH20 = SizedBox(height: lg);
  static const SizedBox gapH24 = SizedBox(height: xl);
  static const SizedBox gapH32 = SizedBox(height: xxl);
  static const SizedBox gapH40 = SizedBox(height: xxxl);
  static const SizedBox gapH48 = SizedBox(height: huge);
}
