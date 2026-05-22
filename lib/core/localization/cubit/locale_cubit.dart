import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_localization.dart';
import 'locale_state.dart';

/// Manages the app's current locale.
///
/// Call [changeLocale] from a settings screen to switch languages.
/// The [EasyLocalization] widget handles persisting the choice
/// automatically, so this cubit simply drives the UI rebuild.
///
/// ```dart
/// // In a settings widget:
/// context.read<LocaleCubit>().changeLocale(context, AppLocalization.english);
/// ```
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit()
      : super(const LocaleState(locale: AppLocalization.startLocale));

  /// Switch the app locale and persist via easy_localization.
  Future<void> changeLocale(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    emit(LocaleState(locale: locale));
  }

  /// Toggle between Arabic ↔ English.
  Future<void> toggleLocale(BuildContext context) async {
    final next = state.locale == AppLocalization.arabic
        ? AppLocalization.english
        : AppLocalization.arabic;
    await changeLocale(context, next);
  }

  /// Whether the current locale is RTL.
  bool get isRtl => state.locale.languageCode == 'ar';
}
