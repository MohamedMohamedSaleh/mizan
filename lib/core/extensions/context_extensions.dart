import 'package:flutter/material.dart';

import '../theme/theme_extensions/theme_extensions.dart';

/// Convenient [BuildContext] extensions to reduce boilerplate.
///
/// ```dart
/// // Instead of:
/// Theme.of(context).extension<AppColorsExtension>()!.primary
///
/// // Write:
/// context.colors.primary
/// ```
extension BuildContextExtensions on BuildContext {
  // ─────────────────────── Theme ─────────────────────────────────
  /// Current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Whether current theme is dark.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // ─────────────────── Custom Extensions ─────────────────────────
  /// Mizan semantic colors (via [AppColorsExtension]).
  AppColorsExtension get colors =>
      theme.extension<AppColorsExtension>()!;

  // ─────────────────── Media Query ───────────────────────────────
  /// Full [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width in logical pixels.
  double get width => mediaQuery.size.width;

  /// Screen height in logical pixels.
  double get height => mediaQuery.size.height;

  /// View padding (e.g. notch, status bar).
  EdgeInsets get padding => mediaQuery.padding;

  /// View insets (e.g. keyboard).
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Device pixel ratio.
  double get pixelRatio => mediaQuery.devicePixelRatio;

  // ─────────────────── Responsive ────────────────────────────────
  /// Mobile: width < 600
  bool get isMobile => width < 600;

  /// Tablet: 600 <= width < 900
  bool get isTablet => width >= 600 && width < 900;

  /// Small laptop: 900 <= width < 1200
  bool get isSmallLaptop => width >= 900 && width < 1200;

  /// Desktop: width >= 1200
  bool get isDesktop => width >= 1200;

  /// Returns a value based on the current breakpoint.
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? smallLaptop,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? smallLaptop ?? tablet ?? mobile;
    if (isSmallLaptop) return smallLaptop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  // ─────────────────── Navigation ────────────────────────────────
  /// Shortcut to [Navigator].
  NavigatorState get navigator => Navigator.of(this);

  /// Shortcut to [FocusScope].
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Dismiss the keyboard.
  void unfocus() => focusScope.unfocus();

  // ─────────────────── Overlay ───────────────────────────────────
  /// Show a [SnackBar] on the nearest [ScaffoldMessenger].
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }
}
