import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import 'route_paths.dart';

// Imports الخاصة بالفريق
import '../../presentation/splash/screens/splash_screen.dart';
import '../../presentation/onboarding/screens/onboarding_screen.dart';
import '../../presentation/navigation/screens/app_shell_screen.dart';
import '../../presentation/home/screens/home_map_screen.dart';
import '../../presentation/place/screens/place_details_screen.dart';
import '../../presentation/place/screens/add_place_screen.dart';
import '../../presentation/nearby/screens/nearby_places_screen.dart';
import '../../presentation/trip/screens/trip_suggestion_screen.dart';

// Imports الخاصة بأيهم (مع المسار الجديد مجلد screens/)
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/register_screen.dart';
import '../../presentation/profile/screens/profile_screen.dart';
import '../../presentation/favorites/screens/favorites_screen.dart';

// Service مؤقت
import '../../core/services/auth_service.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      // --- منطق التوجيه الأساسي ---
      if (state.matchedLocation == RoutePaths.splash) {
        // 🔥 غيّر هذا السطر إذا بدك تروح للـ Home أو Login بدل Favorites
        return AuthService.isLoggedIn ? RoutePaths.favorites : RoutePaths.login;
      }

      // منع الوصول للـ Home إذا كان غير مسجل
      if (state.matchedLocation == RoutePaths.home && !AuthService.isLoggedIn) {
        return RoutePaths.login;
      }

      return null;
    },
    routes: <RouteBase>[
      // ------------------- 1. صفحات البداية -------------------
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
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // ------------------- 2. المصادقة (Auth) -------------------
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

      // ------------------- 3. صفحات أيهم -------------------
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.favorites,
        name: RouteNames.favorites,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const FavoritesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.addPlace,
        name: RouteNames.addPlace,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AddPlaceScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // ------------------- 4. صفحات الفريق (أحمد ومحمد) -------------------
      /*GoRoute(
        path: RoutePaths.placeDetails,
        name: RouteNames.placeDetails,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const PlaceDetailsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),*/
      GoRoute(
        path: RoutePaths.nearby,
        name: RouteNames.nearby,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const NearbyPlacesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.tripSuggestion,
        name: RouteNames.tripSuggestion,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const TripSuggestionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // ------------------- 5. الهيكل الرئيسي (شريط سفلي) -------------------
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
                  child: const HomeMapScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ),
            ],
          ),
          // باقي الأقسام سيضيفها محمد لاحقاً داخل الـ Shell
        ],
      ),
    ],
  );
}
