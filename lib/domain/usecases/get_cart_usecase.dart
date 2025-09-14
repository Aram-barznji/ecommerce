import '../entities/cart_item.dart';

class GetCartUseCase {
  List<CartItem> cart = [];

  Future<List<CartItem>> call() async {
    return cart;
  }
}