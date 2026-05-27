import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/views/auth_splash_view.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_otp_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/auth/presentation/views/verify_register_otp_view.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/dashboard/presentation/widgets/dashboard_shell.dart';
import '../../features/expenses/presentation/cubit/add_expense_cubit.dart';
import '../../features/expenses/presentation/cubit/edit_expense_cubit.dart';
import '../../features/expenses/presentation/cubit/expense_details_cubit.dart';
import '../../features/expenses/presentation/cubit/expenses_cubit.dart';
import '../../features/expenses/presentation/view_model/expense_form_lookups_view_model.dart';
import '../../features/expenses/presentation/views/add_expense_screen.dart';
import '../../features/expenses/presentation/views/edit_expense_screen.dart';
import '../../features/expenses/presentation/views/expense_details_screen.dart';
import '../../features/expenses/presentation/views/expenses_screen.dart';
import '../../features/vendors/presentation/cubit/add_vendor_cubit.dart';
import '../../features/vendors/presentation/cubit/edit_vendor_cubit.dart';
import '../../features/vendors/presentation/cubit/vendors_cubit.dart';
import '../../features/expenses/domain/entities/vendor_entity.dart';
import '../../features/vendors/presentation/views/add_vendor_screen.dart';
import '../../features/vendors/presentation/views/edit_vendor_screen.dart';
import '../../features/vendors/presentation/views/vendors_screen.dart';
import '../di/injection.dart';
import '../localization/locale_keys.dart';
import 'route_names.dart';

/// Application router powered by [GoRouter].
class AppRouter {
  AppRouter(this._authCubit);
  final AuthCubit _authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = _authCubit.state;
      final isAuthenticated = authState is Authenticated;
      final hasCheckedInitialSession = _authCubit.hasCheckedInitialSession;
      final isOnSplash = state.matchedLocation == RoutePaths.splash;

      final isOnAuthPage = state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.loginOtp ||
          state.matchedLocation == RoutePaths.verifyRegisterOtp ||
          state.matchedLocation == RoutePaths.forgotPassword;

      // Keep users on splash while first session check is running.
      if (!hasCheckedInitialSession) {
        return isOnSplash ? null : RoutePaths.splash;
      }

      // After bootstrap, move away from splash based on current auth state.
      if (isOnSplash) {
        return isAuthenticated ? RoutePaths.dashboard : RoutePaths.login;
      }

      if (!isAuthenticated && !isOnAuthPage) {
        return RoutePaths.login;
      }

      if (isAuthenticated && isOnAuthPage) {
        return RoutePaths.dashboard;
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(_authCubit.stream),
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const AuthSplashView(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: RoutePaths.loginOtp,
        name: RouteNames.loginOtp,
        builder: (context, state) => const LoginOtpView(),
      ),
      GoRoute(
        path: RoutePaths.verifyRegisterOtp,
        name: RouteNames.verifyRegisterOtp,
        redirect: (_, state) =>
            state.extra is RegisterOtpPayload ? null : RoutePaths.register,
        builder: (context, state) {
          final payload = state.extra! as RegisterOtpPayload;
          return VerifyRegisterOtpView(payload: payload);
        },
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: '/expenses',
        redirect: (_, __) => RoutePaths.expenses,
      ),
      GoRoute(
        path: '/dashboard/vendors',
        redirect: (_, __) => RoutePaths.vendors,
      ),
      GoRoute(
        path: '/expenses/add',
        redirect: (_, __) => RoutePaths.addExpense,
      ),
      GoRoute(
        path: '/expenses/:id/edit',
        redirect: (_, state) =>
            '/dashboard/expenses/${state.pathParameters['id']}/edit',
      ),
      GoRoute(
        path: '/expenses/:id',
        redirect: (_, state) => '/dashboard/expenses/${state.pathParameters['id']}',
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.dashboard,
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardView(),
          ),
          GoRoute(
            path: RoutePaths.expenses,
            name: RouteNames.expenses,
            builder: (context, state) => BlocProvider(
              create: (_) => sl<ExpensesCubit>(),
              child: const ExpensesScreen(showAppBar: false),
            ),
          ),
          GoRoute(
            path: RoutePaths.addExpense,
            name: RouteNames.addExpense,
            builder: (context, state) {
              final preloadedLookups =
                  state.extra as ExpenseFormLookupsViewModel?;
              return BlocProvider(
                create: (_) => sl<AddExpenseCubit>(),
                child: AddExpenseScreen(initialLookups: preloadedLookups),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.vendors,
            name: RouteNames.vendors,
            builder: (context, state) => BlocProvider(
              create: (_) => sl<VendorsCubit>(),
              child: const VendorsScreen(showAppBar: false),
            ),
          ),
          GoRoute(
            path: RoutePaths.addVendor,
            name: RouteNames.addVendor,
            builder: (context, state) => BlocProvider(
              create: (_) => sl<AddVendorCubit>(),
              child: const AddVendorScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.editVendor,
            name: RouteNames.editVendor,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              final initialVendor = state.extra as VendorEntity?;
              return BlocProvider(
                create: (_) => sl<EditVendorCubit>(),
                child: EditVendorScreen(
                  vendorId: id,
                  initialVendor: initialVendor,
                ),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.editExpense,
            name: RouteNames.editExpense,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return BlocProvider(
                create: (_) => sl<EditExpenseCubit>(),
                child: EditExpenseScreen(expenseId: id),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.expenseDetails,
            name: RouteNames.expenseDetails,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return BlocProvider(
                create: (_) => sl<ExpenseDetailsCubit>(),
                child: ExpenseDetailsScreen(expenseId: id),
              );
            },
          ),
          GoRoute(
            path: RoutePaths.reports,
            name: RouteNames.reports,
            builder: (context, state) => DashboardPlaceholderView(
              title: LocaleKeys.navReports.tr(),
              description: LocaleKeys.reportsGenerate.tr(),
              icon: Icons.assessment_outlined,
            ),
          ),
          GoRoute(
            path: RoutePaths.journalEntries,
            name: RouteNames.journalEntries,
            builder: (context, state) => DashboardPlaceholderView(
              title: LocaleKeys.navJournalEntries.tr(),
              description: LocaleKeys.navGeneralAccounting.tr(),
              icon: Icons.account_balance_outlined,
            ),
          ),
          GoRoute(
            path: RoutePaths.accounts,
            name: RouteNames.accounts,
            builder: (context, state) => DashboardPlaceholderView(
              title: LocaleKeys.navAccounts.tr(),
              description: LocaleKeys.navFinance.tr(),
              icon: Icons.account_tree_outlined,
            ),
          ),
          GoRoute(
            path: RoutePaths.settings,
            name: RouteNames.settings,
            builder: (context, state) => DashboardPlaceholderView(
              title: LocaleKeys.navSettings.tr(),
              description: LocaleKeys.settingsTitle.tr(),
              icon: Icons.settings_outlined,
            ),
          ),
        ],
      ),
    ],
  );
}

/// Converts a [Stream] into a [ChangeNotifier] so GoRouter can listen to it.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
