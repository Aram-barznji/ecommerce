import '../entities/product.dart';
import '../repositories/product_repository.dart';

class AddToCartUseCase {
  final ProductRepository repository;
  
  AddToCartUseCase(this.repository);
  
  Future<bool> call(Product product, int quantity) {
    return repository.addToCart(product, quantity);
  }
}