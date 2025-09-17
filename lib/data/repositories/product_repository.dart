import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../data_sources/local_db.dart';

class ProductRepositoryImpl extends ProductRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  // Mock data
  final List<ProductModel> _mockProducts = const [
    ProductModel(
      id: '1',
      name: 'iPhone 15 Pro',
      description: 'Latest iPhone with advanced camera system',
      price: 999.99,
      imageUrl:
          'https://www.mac4sale.ae/media/catalog/product/cache/b7a400509e775429487e4356d6f4c59b/w/h/whatsapp_image_2023-09-19_at_4.33.56_am_4.jpeg',
      category: 'Electronics',
      stock: 10,
      rating: 4.8,
    ),
    ProductModel(
      id: '2',
      name: 'MacBook Air M2',
      description: 'Powerful laptop with M2 chip',
      price: 1199.99,
      imageUrl:
          'https://mdriveasia.com/cdn/shop/products/MacBook_Air_M2_Starlight_PDP_Image_Position-3__ROSA_1024x1024.jpg?v=1662720350',
      category: 'Electronics',
      stock: 5,
      rating: 4.9,
    ),
    ProductModel(
      id: '3',
      name: 'Nike Air Max',
      description: 'Comfortable running shoes',
      price: 129.99,
      imageUrl:
          'https://www.nike.qa/dw/image/v2/BDVB_PRD/on/demandware.static/-/Sites-akeneo-master-catalog/default/dw76f9d88e/nk/a9d/e/5/1/7/f/a9de517f_23c3_4f24_9f3b_110f7b8df238.jpg?sw=700&sh=700&sm=fit&q=100&strip=false',
      category: 'Fashion',
      stock: 20,
      rating: 4.5,
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProducts;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockProducts
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<bool> addToCart(Product product, int quantity) async {
    final db = await _db.database;

    // Check if item already exists in cart
    final existing = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [product.id],
    );

    if (existing.isNotEmpty) {
      // Update quantity
      final currentQuantity = existing.first['quantity'] as int;
      final newQuantity = currentQuantity + quantity;
      await db.update(
        'cart',
        {'quantity': newQuantity},
        where: 'productId = ?',
        whereArgs: [product.id],
      );
    } else {
      // Insert new item
      await db.insert('cart', {
        'productId': product.id,
        'productData': ProductModel.fromEntity(product).toJson().toString(),
        'quantity': quantity,
      });
    }

    return true;
  }

  @override
  Future<bool> removeFromCart(String productId) async {
    final db = await _db.database;
    final result = await db.delete(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return result > 0;
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    final db = await _db.database;
    final maps = await db.query('cart');

    return maps.map((map) {
      final productId = map['productId'] as String;

      // Find product from mock list (fallback to first product if not found)
      final product = _mockProducts.firstWhere(
        (p) => p.id == productId,
        orElse: () => _mockProducts.first,
      );

      return CartItemModel(
        product: product,
        quantity: map['quantity'] as int,
      );
    }).toList();
  }
}
