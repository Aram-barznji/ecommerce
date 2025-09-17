import '../entities/cart_item.dart';
import '../repositories/product_repository.dart';

class GetCartUseCase {
  final ProductRepository repository;
  
  GetCartUseCase(this.repository);
  
  Future<List<CartItem>> call() {
    return repository.getCartItems();
  }
}