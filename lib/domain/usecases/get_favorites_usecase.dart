import '../entities/favorites.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;
  
  GetFavoritesUseCase(this.repository);
  
  Future<Favorites> call() {
    return repository.getFavorites();
  }
}