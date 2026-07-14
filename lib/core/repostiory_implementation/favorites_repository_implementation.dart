import 'package:app_aq_2/core/constants/keys.dart';
import 'package:app_aq_2/core/services/storage_service.dart';

import '../repository/favorites_repository.dart';

class FavoritesRepoImplement extends FavoritesRepository {
  final StorageService _storage;

  FavoritesRepoImplement(this._storage);

  @override
  List<String> getFavoritesList() {
    return _storage.getList(FavoriteConstants.favoriteKey) ?? [];
  }

  @override
  Future<List<String>> toggleFavoriteId(String id) async {
    final favorites = List<String>.from(getFavoritesList());
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await _storage.saveList(FavoriteConstants.favoriteKey, favorites);
    return favorites;
  }
}
