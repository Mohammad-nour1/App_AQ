abstract class FavoritesRepository {
  List<String> getFavoritesList();
  Future<List<String>> toggleFavoriteId(String id);
}
