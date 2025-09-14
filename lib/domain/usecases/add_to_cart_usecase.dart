import '../entities/cart_item.dart';

class AddToCartUseCase {
  List<CartItem> cart = [];

  void call(int productId, String name, double price) {
    final existingItem = cart.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(productId: productId, name: name, price: price),
    );
    if (cart.contains(existingItem)) {
      cart[cart.indexOf(existingItem)].quantity++;
    } else {
      cart.add(existingItem);
    }
  }
}