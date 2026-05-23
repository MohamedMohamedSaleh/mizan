import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/localization/cubit/locale_cubit.dart';
import '../../../../core/localization/cubit/locale_state.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';

class AuthPreferencesAppBarActions extends StatelessWidget {
  const AuthPreferencesAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system &&
                      Theme.of(context).brightness == Brightness.dark);
              return Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    size: 18,
                  ),
                  Switch.adaptive(
                    value: isDark,
                    onChanged: (_) => context.read<ThemeCubit>().toggleLightDark(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 4),
          Row(
            children: [
              const Icon(Icons.language_outlined, size: 18),
              BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, state) {
                  final isArabic =
                      context.locale.languageCode == AppLocalization.arabic.languageCode;
                  return Tooltip(
                    message: LocaleKeys.changeLanguage.tr(),
                    child: Switch.adaptive(
                      value: isArabic,
                      onChanged: (_) => context.read<LocaleCubit>().toggleLocale(context),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
