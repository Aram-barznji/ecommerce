import 'package:e_commerce/data/repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call(int productId, bool isFavorite) async {
    if (isFavorite) {
      await repository.addFavorite(productId);
    } else {
      await repository.removeFavorite(productId);
    }
  }
}