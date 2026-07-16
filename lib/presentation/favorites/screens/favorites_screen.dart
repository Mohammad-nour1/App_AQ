import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/router/route_names.dart';
import 'package:app_aq_2/core/widgets/search&nearby/items_grid_builder.dart';
import 'package:app_aq_2/presentation/favorites/cubit/favorites_cubit.dart';
import 'package:app_aq_2/presentation/favorites/cubit/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (state is FavoritesError) {
            return Center(
              child: Text(
                state.failure.message,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            );
          }

          if (state is FavoritesLoaded) {
            if (state.favoritePlaces.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start adding places to your favorites',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: itemsGridBuilder(
                  16,
                  state.favoritePlaces,
                  context,
                  onShowOnMap: (place) {
                    context.pushNamed(
                      RouteNames.placeDetails,
                      pathParameters: {'id': place.id},
                    );
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
