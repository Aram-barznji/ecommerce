import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_state.dart';
import '../blocs/favorites/favorites_event.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_state.dart';
import '../widgets/product_item.dart';
import '../widgets/app_navigation.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(FavoritesLoadRequested());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, favoritesState) {
          return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (favoritesState is FavoritesLoading) {
                return AppUtils.buildLoadingWidget();
              } else if (favoritesState is FavoritesLoaded) {
                if (favoritesState.favorites.favoriteProductIds.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, 
                             size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add products to your favorites to see them here',
                          style: TextStyle(color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                if (productState is ProductLoaded) {
                  final favoriteProducts = productState.products
                      .where((product) => favoritesState.favorites
                          .favoriteProductIds.contains(product.id))
                      .toList();
                  
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      return ProductItem(product: favoriteProducts[index]);
                    },
                  );
                }
                
                return AppUtils.buildLoadingWidget();
              } else if (favoritesState is FavoritesError) {
                return AppUtils.buildErrorWidget(
                  favoritesState.message,
                  () => context.read<FavoritesBloc>().add(FavoritesLoadRequested()),
                );
              }
              
              return const SizedBox.shrink();
            },
          );
        },
      ),
      bottomNavigationBar: AppNavigation(),
    );
  }
}