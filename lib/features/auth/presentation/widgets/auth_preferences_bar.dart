import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/localization/cubit/locale_cubit.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';

class AuthPreferencesBar extends StatelessWidget {
  const AuthPreferencesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == AppLocalization.arabic.languageCode;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: [
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            final isDark = themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    Theme.of(context).brightness == Brightness.dark);

            return OutlinedButton.icon(
              onPressed: () => context.read<ThemeCubit>().toggleLightDark(),
              icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
              label: Text(
                isDark
                    ? LocaleKeys.switchToLight.tr()
                    : LocaleKeys.switchToDark.tr(),
              ),
            );
          },
        ),
        OutlinedButton.icon(
          onPressed: () => context.read<LocaleCubit>().toggleLocale(context),
          icon: const Icon(Icons.language_outlined),
          label: Text(
            isArabic ? LocaleKeys.english.tr() : LocaleKeys.arabic.tr(),
          ),
        ),
      ],
    );
  }
}
