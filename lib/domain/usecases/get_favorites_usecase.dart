import 'package:e_commerce/data/repositories/favorites_repository.dart';
import 'package:e_commerce/data/repositories/product_repository.dart';
import 'package:e_commerce/domain/entities/product.dart';


class GetFavoritesUseCase {
  final FavoritesRepository favRepository;
  final ProductRepository productRepository;

  GetFavoritesUseCase(this.favRepository, this.productRepository);

  Future<List<Product>> call() async {
    final favIds = await favRepository.getFavorites();
    final products = await productRepository.getProducts();
    return products.where((p) => favIds.contains(p.id)).toList();
  }
}