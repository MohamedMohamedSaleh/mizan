import 'package:flutter/material.dart';

/// Centralized localization configuration for the Mizan app.
///
/// Contains supported locales, default locale, and the path
/// to translation asset files used by [EasyLocalization].
abstract final class AppLocalization {
  /// Path to the translations JSON directory.
  static const String translationsPath = 'assets/translations';

  /// Arabic — default language.
  static const Locale arabic = Locale('ar');

  /// English.
  static const Locale english = Locale('en');

  /// All locales the app supports.
  static const List<Locale> supportedLocales = [arabic, english];

  /// The locale the app starts with if none is saved.
  static const Locale fallbackLocale = arabic;

  /// The initial/startup locale.
  static const Locale startLocale = arabic;
}
