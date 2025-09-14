import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleFavorite;

  const ProductItem({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.description ?? ''),
        trailing: SizedBox(
          width: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('\$${product.price.toStringAsFixed(2)}'),
              IconButton(icon: const Icon(Icons.favorite_border), onPressed: onToggleFavorite),
              IconButton(icon: const Icon(Icons.add_shopping_cart), onPressed: onAddToCart),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}