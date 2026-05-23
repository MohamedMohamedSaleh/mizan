import 'package:flutter/material.dart';

import '../theme/theme_extensions/theme_extensions.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  AppColorsExtension get colors => theme.extension<AppColorsExtension>()!;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get width => mediaQuery.size.width;
  double get height => mediaQuery.size.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  double get pixelRatio => mediaQuery.devicePixelRatio;

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 900;
  bool get isSmallLaptop => width >= 900 && width < 1200;
  bool get isDesktop => width >= 1200;

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

  NavigatorState get navigator => Navigator.of(this);
  FocusScopeNode get focusScope => FocusScope.of(this);
  void unfocus() => focusScope.unfocus();
}
