import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/send_email_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_email_otp_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../router/app_router.dart';

final sl = GetIt.instance;

/// Initialise all dependencies.
///
/// Call this once before [runApp] in `main()`.
Future<void> initDependencies() async {
  // ──────────── External ─────────────
  sl.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  // ──────────── Data Sources ─────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // ──────────── Repositories ─────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // ──────────── Use Cases ────────────
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SendEmailOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyEmailOtpUseCase(sl<AuthRepository>()));

  // ──────────── Cubits ───────────────
  sl.registerLazySingleton(
    () => AuthCubit(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      sendEmailOtpUseCase: sl<SendEmailOtpUseCase>(),
      verifyEmailOtpUseCase: sl<VerifyEmailOtpUseCase>(),
    ),
  );

  // ──────────── Router ───────────────
  sl.registerLazySingleton(() => AppRouter(sl<AuthCubit>()));
}
