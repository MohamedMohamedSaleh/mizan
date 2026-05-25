import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import 'core/constants/supabase_constants.dart';
import 'core/di/injection.dart';
import 'core/localization/app_localization.dart';
import 'core/localization/cubit/locale_cubit.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  SupabaseConstants.validate();

  await Supabase.initialize(
    url: SupabaseConstants.url,
    anonKey: SupabaseConstants.anonKey,
  );

  await initDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.translationsPath,
      fallbackLocale: AppLocalization.fallbackLocale,
      startLocale: AppLocalization.startLocale,
      child: const MizanApp(),
    ),
  );
}

class MizanApp extends StatefulWidget {
  const MizanApp({super.key});

  @override
  State<MizanApp> createState() => _MizanAppState();
}

class _MizanAppState extends State<MizanApp> {
  late final AuthCubit _authCubit;
  late final AppRouter _appRouter;
  late final LocaleCubit _localeCubit;
  late final ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
    _appRouter = sl<AppRouter>();
    _localeCubit = LocaleCubit();
    _themeCubit = ThemeCubit()..loadTheme();
    _authCubit.checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _localeCubit..syncFromLocale(context.locale)),
        BlocProvider.value(value: _themeCubit),
        BlocProvider.value(value: _authCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return ToastificationWrapper(
            child: MaterialApp.router(
              title: 'Mizan',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                ...context.localizationDelegates,
                ...context.supportedLocales.map(
                  (e) => CountrySelectorLocalization.delegate,
                ),
              ],
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              routerConfig: _appRouter.router,
            ),
          );
        },
      ),
    );
  }
}
