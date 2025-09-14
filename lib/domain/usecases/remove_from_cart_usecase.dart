import '../entities/cart_item.dart';

class RemoveFromCartUseCase {
  void call(List<CartItem> cart, int productId) {
    cart.removeWhere((item) => item.productId == productId);
  }
}