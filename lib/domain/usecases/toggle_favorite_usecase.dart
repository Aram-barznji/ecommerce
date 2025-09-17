import '../entities/product.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;
  
  ToggleFavoriteUseCase(this.repository);
  
  Future<bool> call(Product product) {
    return repository.toggleFavorite(product);
  }
}