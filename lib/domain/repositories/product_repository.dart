import '../entities/product.dart';
import '../entities/cart_item.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> searchProducts(String query);
  Future<bool> addToCart(Product product, int quantity);
  Future<bool> removeFromCart(String productId);
  Future<List<CartItem>> getCartItems();
}