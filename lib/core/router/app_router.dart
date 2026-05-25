import 'dart:async';

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
import '../../features/expenses/presentation/cubit/add_expense_cubit.dart';
import '../../features/expenses/presentation/cubit/edit_expense_cubit.dart';
import '../../features/expenses/presentation/cubit/expense_details_cubit.dart';
import '../../features/expenses/presentation/cubit/expenses_cubit.dart';
import '../../features/expenses/presentation/view_model/expense_form_lookups_view_model.dart';
import '../../features/expenses/presentation/views/add_expense_screen.dart';
import '../../features/expenses/presentation/views/edit_expense_screen.dart';
import '../../features/expenses/presentation/views/expense_details_screen.dart';
import '../../features/expenses/presentation/views/expenses_screen.dart';
import '../di/injection.dart';
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
        builder: (context, state) {
          final payload = state.extra as RegisterOtpPayload?;
          if (payload == null) {
            return const LoginView();
          }
          return VerifyRegisterOtpView(payload: payload);
        },
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
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
          child: const ExpensesScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.addExpense,
        name: RouteNames.addExpense,
        builder: (context, state) {
          final preloadedLookups = state.extra as ExpenseFormLookupsViewModel?;
          return BlocProvider(
            create: (_) => sl<AddExpenseCubit>(),
            child: AddExpenseScreen(initialLookups: preloadedLookups),
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
