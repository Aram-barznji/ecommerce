import 'package:e_commerce/data/repositories/product_repository.dart';
import 'package:e_commerce/domain/entities/product.dart';


class SearchProductsUseCase {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  Future<List<Product>> call(String query) async {
    return await repository.searchProducts(query);
  }
}