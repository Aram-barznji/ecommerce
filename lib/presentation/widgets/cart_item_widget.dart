import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onRemove;

  const CartItemWidget({super.key, required this.item, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('Quantity: ${item.quantity} | Total: \$${item.total.toStringAsFixed(2)}'),
      trailing: IconButton(
        icon: const Icon(Icons.remove_circle),
        onPressed: onRemove,
      ),
    );
  }
}