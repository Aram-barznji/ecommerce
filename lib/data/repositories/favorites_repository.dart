import '../../domain/repositories/favorites_repository.dart';
import '../../domain/entities/favorites.dart';
import '../../domain/entities/product.dart';
import '../data_sources/local_db.dart';

class FavoritesRepositoryImpl extends FavoritesRepository {
  final LocalDatabase _db = LocalDatabase.instance;
  
  @override
  Future<bool> toggleFavorite(Product product) async {
    final db = await _db.database;
    
    final existing = await db.query(
      'favorites',
      where: 'productId = ?',
      whereArgs: [product.id],
    );
    
    if (existing.isNotEmpty) {
      // Remove from favorites
      await db.delete(
        'favorites',
        where: 'productId = ?',
        whereArgs: [product.id],
      );
      return false;
    } else {
      // Add to favorites
      await db.insert('favorites', {
        'productId': product.id,
        'addedAt': DateTime.now().millisecondsSinceEpoch,
      });
      return true;
    }
  }
  
  @override
  Future<Favorites> getFavorites() async {
    final db = await _db.database;
    final maps = await db.query('favorites');
    
    final productIds = maps.map((map) => map['productId'] as String).toList();
    
    return Favorites(favoriteProductIds: productIds);
  }
  
  @override
  Future<bool> isFavorite(String productId) async {
    final db = await _db.database;
    final result = await db.query(
      'favorites',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }
}