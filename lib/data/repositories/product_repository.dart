import 'package:e_commerce/core/utils.dart';
import 'package:e_commerce/data/models/product_model.dart';

import '../../domain/entities/product.dart';
import '../data_sources/local_db.dart';
import '../../core/constants.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> searchProducts(String query);
}

class ProductRepositoryImpl implements ProductRepository {
  final LocalDB localDB;

  ProductRepositoryImpl(this.localDB);

  @override
  Future<List<Product>> getProducts() async {
    final db = await localDB.database;
    final result = await db.query(Constants.productTable);
    return result.map((e) => ProductModel.fromMap(e)).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = await getProducts();
    return Utils.filterList(products, query, (p) => p.name); // Use Utils for search
  }
}