import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../widgets/product_item.dart';
import '../widgets/app_navigation.dart';
import '../../core/notification_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    final cartBloc = context.read<CartBloc>();
    final favoritesBloc = context.read<FavoritesBloc>();

    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                productBloc.add(ProductSearchRequested(query));
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoadSuccess) {
            final products = state.products;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  onAddToCart: () {
                    cartBloc.add(CartAddRequested(
                      product.id,
                      product.name,
                      product.price,
                    ));
                    NotificationService().showNotification(
                      id: 2,
                      title: 'Added to Cart',
                      body: '${product.name} added to cart.',
                    );
                  },
                  onToggleFavorite: () {
                    favoritesBloc.add(FavoritesToggleRequested(product.id, true)); // Toggle logic
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Failed to load products'));
          }
        },
      ),
      bottomNavigationBar: const AppNavigation(currentIndex: 0),
    );
  }
}