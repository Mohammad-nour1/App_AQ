import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/auth/register_screen.dart';
import 'route_names.dart';
import 'route_paths.dart';
import '../../presentation/splash/screens/splash_screen.dart';
import '../../presentation/navigation/screens/app_shell_screen.dart';
import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../core/services/auth_service.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      if (state.matchedLocation == RoutePaths.splash) {
        return AuthService.isLoggedIn ? RoutePaths.home : RoutePaths.login;
      }

      if (state.matchedLocation == RoutePaths.home && !AuthService.isLoggedIn) {
        return RoutePaths.login;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScreen(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const HomeScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
