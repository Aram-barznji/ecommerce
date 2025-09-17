import '../entities/product.dart';
import '../entities/favorites.dart';

abstract class FavoritesRepository {
  Future<bool> toggleFavorite(Product product);
  Future<Favorites> getFavorites();
  Future<bool> isFavorite(String productId);
}