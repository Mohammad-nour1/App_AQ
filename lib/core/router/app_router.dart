import 'package:app_aq_2/core/di/injector.dart';
import 'package:app_aq_2/core/services/auth_service.dart';
import 'package:app_aq_2/presentation/auth/login_screen.dart';
import 'package:app_aq_2/presentation/auth/register_screen.dart';
import 'package:app_aq_2/presentation/favorites/cubit/favorites_cubit.dart';
import 'package:app_aq_2/presentation/favorites/screens/favorites_screen.dart';
import 'package:app_aq_2/presentation/filter/screens/filter_screen.dart';
import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';
import 'package:app_aq_2/presentation/home/screens/home_map_screen.dart';
import 'package:app_aq_2/presentation/nearby/screens/nearby_places_screen.dart';
import 'package:app_aq_2/presentation/onboarding/screens/onboarding_screen.dart';
import 'package:app_aq_2/presentation/place/screens/add_place_screen.dart';
import 'package:app_aq_2/presentation/place/screens/place_details_screen.dart';
import 'package:app_aq_2/presentation/profile/cubit/profile_cubit.dart';
import 'package:app_aq_2/presentation/profile/screens/profile_screen.dart';
import 'package:app_aq_2/presentation/search/screens/search_screen.dart';
import 'package:app_aq_2/presentation/trip/cubit/trip_cubit.dart';
import 'package:app_aq_2/presentation/splash/cubit/splash_cubit.dart';
import 'package:app_aq_2/presentation/trip/screens/trip_suggestion_screen.dart';
import 'package:app_aq_2/presentation/trip/screens/trip_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import 'route_paths.dart';
import '../../presentation/splash/screens/splash_screen.dart';
import '../../presentation/navigation/screens/app_shell_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final isLoggedIn = AuthService.isLoggedIn;
      final isSplash = state.matchedLocation == RoutePaths.splash;
      final isHomeRoute = state.matchedLocation == RoutePaths.homeMap;
      final isAuthRoute =
          state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.onboarding;

      // Don't redirect from splash - let splash screen handle navigation
      // This ensures splash screen is visible before redirecting
      if (isSplash) {
        return null;
      }

      // If on home and not logged in, go to login
      if (isHomeRoute && !isLoggedIn && !isAuthRoute) {
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
          child: BlocProvider<SplashCubit>(
            create: (_) => SplashCubit(),
            child: const SplashScreen(),
          ),
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
                path: RoutePaths.homeMap,
                name: RouteNames.homeMap,
                pageBuilder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final targetPlaceId = extra?['targetPlaceId'] as String?;
                  return CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: HomeMapScreen(targetPlaceId: targetPlaceId),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.search,
                name: RouteNames.search,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const SearchScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.favorites,
                name: RouteNames.favorites,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) => getIt<FavoritesCubit>(),
                    child: const FavoritesScreen(),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (_) => getIt<ProfileCubit>(),
                    child: const ProfileScreen(),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.placeDetails,
        name: RouteNames.placeDetails,
        pageBuilder: (context, state) {
          final placeId = state.pathParameters['id'] ?? '';
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: PlaceDetailsScreen(placeId: placeId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: RoutePaths.addPlace,
        name: RouteNames.addPlace,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AddPlaceScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.nearbyPlaces,
        name: RouteNames.nearbyPlaces,
        pageBuilder: (context, state) {
          final userCords = (state.extra as Map<String, dynamic>)["userCords"];
          final placeIds = (state.extra as Map<String, dynamic>)["placeIds"];

          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: NearbyPlacesScreen(placeIds: placeIds, userCords: userCords),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),
      GoRoute(
        path: RoutePaths.tripSuggestion,
        name: RouteNames.tripSuggestion,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => getIt<TripCubit>(),
            child: const TripSuggestionScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.tripPlan,
        name: RouteNames.tripPlan,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const TripPlanScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RoutePaths.filter,
        name: RouteNames.filter,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: BlocProvider.value(
            value: context.read<HomeCubit>(),
            child: const FilterScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
}
