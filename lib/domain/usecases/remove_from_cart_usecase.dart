import '../repositories/product_repository.dart';

class RemoveFromCartUseCase {
  final ProductRepository repository;
  
  RemoveFromCartUseCase(this.repository);
  
  Future<bool> call(String productId) {
    return repository.removeFromCart(productId);
  }
}