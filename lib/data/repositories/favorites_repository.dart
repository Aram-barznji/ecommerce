import '../data_sources/local_preferences.dart';

abstract class FavoritesRepository {
  Future<List<int>> getFavorites();
  Future<void> addFavorite(int productId);
  Future<void> removeFavorite(int productId);
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final LocalPreferences prefs;

  FavoritesRepositoryImpl(this.prefs);

  @override
  Future<List<int>> getFavorites() async {
    return prefs.getFavorites();
  }

  @override
  Future<void> addFavorite(int productId) async {
    final favorites = await getFavorites();
    if (!favorites.contains(productId)) {
      favorites.add(productId);
      await prefs.setFavorites(favorites);
    }
  }

  @override
  Future<void> removeFavorite(int productId) async {
    final favorites = await getFavorites();
    favorites.remove(productId);
    await prefs.setFavorites(favorites);
  }
}