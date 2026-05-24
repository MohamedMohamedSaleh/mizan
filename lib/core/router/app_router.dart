import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/login_otp_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/auth/presentation/views/verify_register_otp_view.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';
import 'route_names.dart';

/// Application router powered by [GoRouter].
///
/// Handles auth redirect logic:
/// - If user is NOT authenticated → redirect to /login
/// - If user IS authenticated and on auth pages → redirect to /dashboard
class AppRouter {
  AppRouter(this._authCubit);
  final AuthCubit _authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.login,
    debugLogDiagnostics: true,

    // ──────── Auth Redirect ────────
    redirect: (context, state) {
      final authState = _authCubit.state;
      final isAuthenticated = authState is Authenticated;

      final isOnAuthPage = state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.loginOtp ||
          state.matchedLocation == RoutePaths.verifyRegisterOtp ||
          state.matchedLocation == RoutePaths.forgotPassword;

      // Not authenticated and trying to access protected page → login
      if (!isAuthenticated && !isOnAuthPage) {
        return RoutePaths.login;
      }

      // Authenticated but still on auth page → dashboard
      if (isAuthenticated && isOnAuthPage) {
        return RoutePaths.dashboard;
      }

      return null; // no redirect
    },

    // Listen to auth state changes to re-evaluate redirects.
    refreshListenable: GoRouterRefreshStream(_authCubit.stream),

    routes: [
      // ──────── Auth Routes ────────
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

      // ──────── Dashboard (temporary placeholder) ────────
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardView(),
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
