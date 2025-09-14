class CartItemModel {
  final int productId;
  final String name;
  final double price;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}