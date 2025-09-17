import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_event.dart';
import '../widgets/product_item.dart';
import '../widgets/app_navigation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductLoadRequested());
    context.read<CartBloc>().add(CartLoadRequested());
    context.read<FavoritesBloc>().add(FavoritesLoadRequested());
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _search(String query) {
    if (query.isEmpty) {
      context.read<ProductBloc>().add(ProductSearchCleared());
    } else {
      context.read<ProductBloc>().add(ProductSearchRequested(query));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _search,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return AppUtils.buildLoadingWidget();
          } else if (state is ProductLoaded || state is ProductSearchLoaded) {
            final products = state is ProductLoaded 
                ? state.products 
                : (state as ProductSearchLoaded).products;
            
            if (products.isEmpty) {
              return const Center(child: Text('No products found'));
            }
            
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) => ProductItem(product: products[index]),
            );
          } else if (state is ProductError) {
            return AppUtils.buildErrorWidget(
              state.message,
              () => context.read<ProductBloc>().add(ProductLoadRequested()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: AppNavigation(),
    );
  }
}