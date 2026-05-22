import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
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
      final isAuthenticated = authState is AuthAuthenticated;

      final isOnAuthPage = state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
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
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),

      // ──────── Dashboard (temporary placeholder) ────────
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const _DashboardPlaceholder(),
      ),
    ],
  );
}

/// Temporary dashboard placeholder until the dashboard feature is built.
class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<AuthCubit>().logout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Converts a [Stream] into a [ChangeNotifier] so GoRouter can listen to it.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
