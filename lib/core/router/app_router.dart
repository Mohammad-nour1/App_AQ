import 'package:app_aq_2/core/services/auth_service.dart';
import 'package:app_aq_2/presentation/favorites/screens/favorites_screen.dart';
import 'package:app_aq_2/presentation/filter/screens/filter_screen.dart';
import 'package:app_aq_2/presentation/home/screens/home_map_screen.dart';
import 'package:app_aq_2/presentation/nearby/screens/nearby_places_screen.dart';
import 'package:app_aq_2/presentation/place/screens/add_place_screen.dart';
import 'package:app_aq_2/presentation/place/screens/place_details_screen.dart';
import 'package:app_aq_2/presentation/profile/screens/profile_screen.dart';
import 'package:app_aq_2/presentation/search/screens/search_screen.dart';
import 'package:app_aq_2/presentation/trip/screens/trip_suggestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/auth/register_screen.dart';
import 'route_names.dart';
import 'route_paths.dart';
import '../../presentation/splash/screens/splash_screen.dart';
import '../../presentation/onboarding/screens/onboarding_screen.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/register_screen.dart';
import '../../presentation/navigation/screens/app_shell_screen.dart';

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
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const HomeMapScreen(),
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
                  child: const FavoritesScreen(),
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
                  child: const ProfileScreen(),
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
          child: const TripSuggestionScreen(),
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
          child: const FilterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
}
