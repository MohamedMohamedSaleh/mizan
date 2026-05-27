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
import '../../features/auth/domain/usecases/resend_register_otp_usecase.dart';
import '../../features/auth/domain/usecases/send_email_otp_usecase.dart';
import '../../features/auth/domain/usecases/upsert_profile_usecase.dart';
import '../../features/auth/domain/usecases/verify_email_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_register_otp_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/expenses/data/datasources/accounts_remote_data_source.dart';
import '../../features/expenses/data/datasources/expense_categories_remote_data_source.dart';
import '../../features/expenses/data/datasources/expenses_remote_data_source.dart';
import '../../features/expenses/data/datasources/journal_entries_remote_data_source.dart';
import '../../features/expenses/data/datasources/taxes_remote_data_source.dart';
import '../../features/expenses/data/datasources/vendors_remote_data_source.dart';
import '../../features/expenses/data/repositories/accounts_repository_impl.dart';
import '../../features/expenses/data/repositories/expense_categories_repository_impl.dart';
import '../../features/expenses/data/repositories/expenses_repository_impl.dart';
import '../../features/expenses/data/repositories/journal_entries_repository_impl.dart';
import '../../features/expenses/data/repositories/taxes_repository_impl.dart';
import '../../features/expenses/data/repositories/vendors_repository_impl.dart';
import '../../features/expenses/data/services/accounting_seed_service_impl.dart';
import '../../features/expenses/domain/repositories/accounts_repository.dart';
import '../../features/expenses/domain/repositories/expense_categories_repository.dart';
import '../../features/expenses/domain/repositories/expenses_repository.dart';
import '../../features/expenses/domain/repositories/journal_entries_repository.dart';
import '../../features/expenses/domain/repositories/taxes_repository.dart';
import '../../features/expenses/domain/repositories/vendors_repository.dart';
import '../../features/expenses/domain/services/accounting_seed_service.dart';
import '../../features/expenses/domain/usecases/add_expense_usecase.dart';
import '../../features/expenses/domain/usecases/delete_expense_usecase.dart';
import '../../features/expenses/domain/usecases/get_expense_details_usecase.dart';
import '../../features/expenses/domain/usecases/get_expenses_summary_usecase.dart';
import '../../features/expenses/domain/usecases/get_expenses_usecase.dart';
import '../../features/expenses/domain/usecases/load_expense_form_lookups_usecase.dart';
import '../../features/expenses/domain/usecases/seed_accounting_data_usecase.dart';
import '../../features/expenses/domain/usecases/update_expense_usecase.dart';
import '../../features/expenses/presentation/cubit/add_expense_cubit.dart';
import '../../features/expenses/presentation/cubit/edit_expense_cubit.dart';
import '../../features/expenses/presentation/cubit/expense_details_cubit.dart';
import '../../features/expenses/presentation/cubit/expenses_cubit.dart';
import '../../features/vendors/domain/usecases/create_vendor_usecase.dart';
import '../../features/vendors/domain/usecases/delete_vendor_usecase.dart';
import '../../features/vendors/domain/usecases/get_vendor_by_id_usecase.dart';
import '../../features/vendors/domain/usecases/get_vendors_usecase.dart';
import '../../features/vendors/domain/usecases/update_vendor_usecase.dart';
import '../../features/vendors/presentation/cubit/add_vendor_cubit.dart';
import '../../features/vendors/presentation/cubit/edit_vendor_cubit.dart';
import '../../features/vendors/presentation/cubit/vendors_cubit.dart';
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
  sl.registerLazySingleton<ExpensesRemoteDataSource>(
    () => ExpensesRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<AccountsRemoteDataSource>(
    () => AccountsRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<ExpenseCategoriesRemoteDataSource>(
    () => ExpenseCategoriesRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<VendorsRemoteDataSource>(
    () => VendorsRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<TaxesRemoteDataSource>(
    () => TaxesRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<JournalEntriesRemoteDataSource>(
    () => JournalEntriesRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<AccountingSeedService>(
    () => AccountingSeedServiceImpl(sl<SupabaseClient>()),
  );

  // ──────────── Repositories ─────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(sl<ExpensesRemoteDataSource>()),
  );
  sl.registerLazySingleton<AccountsRepository>(
    () => AccountsRepositoryImpl(sl<AccountsRemoteDataSource>()),
  );
  sl.registerLazySingleton<ExpenseCategoriesRepository>(
    () => ExpenseCategoriesRepositoryImpl(
      sl<ExpenseCategoriesRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<VendorsRepository>(
    () => VendorsRepositoryImpl(sl<VendorsRemoteDataSource>()),
  );
  sl.registerLazySingleton<TaxesRepository>(
    () => TaxesRepositoryImpl(sl<TaxesRemoteDataSource>()),
  );
  sl.registerLazySingleton<JournalEntriesRepository>(
    () => JournalEntriesRepositoryImpl(sl<JournalEntriesRemoteDataSource>()),
  );

  // ──────────── Use Cases ────────────
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SendEmailOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyEmailOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
      () => VerifyRegisterOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
      () => ResendRegisterOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpsertProfileUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => SeedAccountingDataUseCase(sl<AccountingSeedService>()),
  );
  sl.registerLazySingleton(() => GetExpensesUseCase(sl<ExpensesRepository>()));
  sl.registerLazySingleton(
    () => GetExpenseDetailsUseCase(sl<ExpensesRepository>()),
  );
  sl.registerLazySingleton(
    () => GetExpensesSummaryUseCase(sl<ExpensesRepository>()),
  );
  sl.registerLazySingleton(
    () => AddExpenseUseCase(
      expensesRepository: sl<ExpensesRepository>(),
      categoriesRepository: sl<ExpenseCategoriesRepository>(),
      journalEntriesRepository: sl<JournalEntriesRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateExpenseUseCase(
      expensesRepository: sl<ExpensesRepository>(),
      categoriesRepository: sl<ExpenseCategoriesRepository>(),
      journalEntriesRepository: sl<JournalEntriesRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteExpenseUseCase(
      expensesRepository: sl<ExpensesRepository>(),
      journalEntriesRepository: sl<JournalEntriesRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () => LoadExpenseFormLookupsUseCase(
      accountsRepository: sl<AccountsRepository>(),
      categoriesRepository: sl<ExpenseCategoriesRepository>(),
      vendorsRepository: sl<VendorsRepository>(),
      taxesRepository: sl<TaxesRepository>(),
      seedAccountingDataUseCase: sl<SeedAccountingDataUseCase>(),
    ),
  );
  sl.registerLazySingleton(() => GetVendorsUseCase(sl<VendorsRepository>()));
  sl.registerLazySingleton(
    () => GetVendorByIdUseCase(sl<VendorsRepository>()),
  );
  sl.registerLazySingleton(() => CreateVendorUseCase(sl<VendorsRepository>()));
  sl.registerLazySingleton(() => UpdateVendorUseCase(sl<VendorsRepository>()));
  sl.registerLazySingleton(() => DeleteVendorUseCase(sl<VendorsRepository>()));

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
      verifyRegisterOtpUseCase: sl<VerifyRegisterOtpUseCase>(),
      resendRegisterOtpUseCase: sl<ResendRegisterOtpUseCase>(),
      upsertProfileUseCase: sl<UpsertProfileUseCase>(),
      seedAccountingDataUseCase: sl<SeedAccountingDataUseCase>(),
    ),
  );
  sl.registerFactory(
    () => ExpensesCubit(
      getExpensesUseCase: sl<GetExpensesUseCase>(),
      deleteExpenseUseCase: sl<DeleteExpenseUseCase>(),
      loadLookupsUseCase: sl<LoadExpenseFormLookupsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => AddExpenseCubit(
      loadLookupsUseCase: sl<LoadExpenseFormLookupsUseCase>(),
      addExpenseUseCase: sl<AddExpenseUseCase>(),
      vendorsRepository: sl<VendorsRepository>(),
      categoriesRepository: sl<ExpenseCategoriesRepository>(),
    ),
  );
  sl.registerFactory(
    () => ExpenseDetailsCubit(
      getExpenseDetailsUseCase: sl<GetExpenseDetailsUseCase>(),
      deleteExpenseUseCase: sl<DeleteExpenseUseCase>(),
      loadLookupsUseCase: sl<LoadExpenseFormLookupsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => EditExpenseCubit(
      loadLookupsUseCase: sl<LoadExpenseFormLookupsUseCase>(),
      addExpenseUseCase: sl<AddExpenseUseCase>(),
      vendorsRepository: sl<VendorsRepository>(),
      categoriesRepository: sl<ExpenseCategoriesRepository>(),
      getExpenseDetailsUseCase: sl<GetExpenseDetailsUseCase>(),
      updateExpenseUseCase: sl<UpdateExpenseUseCase>(),
    ),
  );
  sl.registerFactory(
    () => VendorsCubit(
      getVendorsUseCase: sl<GetVendorsUseCase>(),
      deleteVendorUseCase: sl<DeleteVendorUseCase>(),
    ),
  );
  sl.registerFactory(
    () => AddVendorCubit(
      createVendorUseCase: sl<CreateVendorUseCase>(),
    ),
  );
  sl.registerFactory(
    () => EditVendorCubit(
      createVendorUseCase: sl<CreateVendorUseCase>(),
      getVendorByIdUseCase: sl<GetVendorByIdUseCase>(),
      updateVendorUseCase: sl<UpdateVendorUseCase>(),
    ),
  );

  // ──────────── Router ───────────────
  sl.registerLazySingleton(() => AppRouter(sl<AuthCubit>()));
}
