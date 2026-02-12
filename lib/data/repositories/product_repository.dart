import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../data_sources/local_db.dart';

class ProductRepositoryImpl extends ProductRepository {
  final LocalDatabase _db = LocalDatabase.instance;

  // Expanded mock data – 12 products across 5 categories
  final List<ProductModel> _mockProducts = const [
    // --- Electronics ---
    ProductModel(
      id: '1',
      name: 'iPhone 15 Pro',
      description:
          'The latest iPhone with a titanium design, A17 Pro chip, and an advanced 48MP camera system. Capture stunning photos in any light.',
      price: 999.99,
      imageUrl:
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-naturaltitanium?wid=400&hei=400&fmt=jpeg',
      category: 'Electronics',
      stock: 10,
      rating: 4.8,
    ),
    ProductModel(
      id: '2',
      name: 'MacBook Air M2',
      description:
          'Supercharged by the M2 chip, redesigned with a stunning Liquid Retina display, MagSafe charging, and up to 18 hours of battery life.',
      price: 1199.99,
      imageUrl:
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mba13-midnight-select-202402?wid=400&hei=400&fmt=jpeg',
      category: 'Electronics',
      stock: 5,
      rating: 4.9,
    ),
    ProductModel(
      id: '3',
      name: 'Sony WH-1000XM5',
      description:
          'Industry-leading noise cancellation headphones with exceptional sound quality, 30-hour battery life, and ultra-comfortable design.',
      price: 349.99,
      imageUrl:
          'https://m.media-amazon.com/images/I/51aXvjzcukL._AC_SL1500_.jpg',
      category: 'Electronics',
      stock: 15,
      rating: 4.7,
    ),
    // --- Fashion ---
    ProductModel(
      id: '4',
      name: 'Nike Air Max 270',
      description:
          'The Nike Air Max 270 delivers visible cushioning under every step. Updated for modern comfort with a sleek, sporty design.',
      price: 150.00,
      imageUrl:
          'https://static.nike.com/a/images/t_default/eijcwbmvixtvbbrucboa/air-max-270-shoes-2V5C4p.png',
      category: 'Fashion',
      stock: 20,
      rating: 4.5,
    ),
    ProductModel(
      id: '5',
      name: 'Levi\'s 501 Original Jeans',
      description:
          'The iconic straight fit jean that started it all. Crafted from premium denim with a button fly and signature styling.',
      price: 69.50,
      imageUrl:
          'https://m.media-amazon.com/images/I/61fOfX7rQUL._AC_SL1500_.jpg',
      category: 'Fashion',
      stock: 30,
      rating: 4.4,
    ),
    ProductModel(
      id: '6',
      name: 'Ray-Ban Aviator Classic',
      description:
          'Timeless aviator sunglasses with gold-tone metal frame and iconic teardrop shape. 100% UV protection crystal lenses.',
      price: 163.00,
      imageUrl:
          'https://m.media-amazon.com/images/I/41CQzR2MX+L._AC_SL1000_.jpg',
      category: 'Fashion',
      stock: 12,
      rating: 4.6,
    ),
    // --- Home ---
    ProductModel(
      id: '7',
      name: 'Dyson V15 Detect',
      description:
          'The most powerful, intelligent cordless vacuum. Reveals hidden dust with a laser, and shows proof of a deep clean.',
      price: 749.99,
      imageUrl:
          'https://m.media-amazon.com/images/I/51qiRxcyYKL._AC_SL1500_.jpg',
      category: 'Home',
      stock: 8,
      rating: 4.7,
    ),
    ProductModel(
      id: '8',
      name: 'Nespresso Vertuo Next',
      description:
          'Premium coffee machine that brews barista-quality coffee and espresso at the touch of a button with Centrifusion technology.',
      price: 179.00,
      imageUrl:
          'https://m.media-amazon.com/images/I/61veDySsKdL._AC_SL1500_.jpg',
      category: 'Home',
      stock: 18,
      rating: 4.3,
    ),
    // --- Sports ---
    ProductModel(
      id: '9',
      name: 'Apple Watch Ultra 2',
      description:
          'The most rugged and capable Apple Watch. GPS + Cellular, 49mm titanium case, precision dual-frequency GPS, and up to 36 hours of battery.',
      price: 799.00,
      imageUrl:
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/watch-ultra-2?wid=400&hei=400&fmt=jpeg',
      category: 'Sports',
      stock: 7,
      rating: 4.8,
    ),
    ProductModel(
      id: '10',
      name: 'Yoga Mat Premium',
      description:
          'Extra thick 6mm non-slip exercise mat with alignment lines. Perfect for yoga, pilates, and floor exercises. Eco-friendly materials.',
      price: 39.99,
      imageUrl:
          'https://m.media-amazon.com/images/I/71HVxxowXsL._AC_SL1500_.jpg',
      category: 'Sports',
      stock: 50,
      rating: 4.5,
    ),
    // --- Books ---
    ProductModel(
      id: '11',
      name: 'Atomic Habits',
      description:
          'By James Clear. A proven framework for improving every day. Learn how tiny changes in behavior can lead to remarkable results.',
      price: 16.99,
      imageUrl:
          'https://m.media-amazon.com/images/I/81YkqyaFVEL._AC_SL1500_.jpg',
      category: 'Books',
      stock: 100,
      rating: 4.9,
    ),
    ProductModel(
      id: '12',
      name: 'The Psychology of Money',
      description:
          'By Morgan Housel. Timeless lessons on wealth, greed, and happiness. 19 short stories exploring the strange ways people think about money.',
      price: 14.99,
      imageUrl:
          'https://m.media-amazon.com/images/I/81Dky+tD+pL._AC_SL1500_.jpg',
      category: 'Books',
      stock: 80,
      rating: 4.7,
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
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase()))
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

      // Find product from mock list
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
