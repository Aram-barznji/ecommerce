import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_state.dart';
import '../blocs/favorites/favorites_event.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_state.dart';
import '../widgets/product_item.dart';
import '../widgets/app_navigation.dart';
import 'product_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'My Wishlist',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),

            Expanded(
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favoritesState) {
                  return BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, productState) {
                      if (favoritesState is FavoritesLoading) {
                        return AppUtils.buildLoadingWidget();
                      } else if (favoritesState is FavoritesLoaded) {
                        if (favoritesState
                            .favorites.favoriteProductIds.isEmpty) {
                          return AppUtils.buildEmptyState(
                            icon: Icons.favorite_border_rounded,
                            title: 'No favourites yet',
                            subtitle:
                                'Tap the ♥ on any product to save it here',
                          );
                        }

                        if (productState is ProductLoaded) {
                          final favoriteProducts = productState.products
                              .where((product) => favoritesState
                                  .favorites.favoriteProductIds
                                  .contains(product.id))
                              .toList();

                          if (favoriteProducts.isEmpty) {
                            return AppUtils.buildEmptyState(
                              icon: Icons.favorite_border_rounded,
                              title: 'No favourites yet',
                              subtitle:
                                  'Tap the ♥ on any product to save it here',
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.62,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemCount: favoriteProducts.length,
                            itemBuilder: (context, index) {
                              return ProductItem(
                                product: favoriteProducts[index],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailPage(
                                        product: favoriteProducts[index]),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return AppUtils.buildLoadingWidget();
                      } else if (favoritesState is FavoritesError) {
                        return AppUtils.buildErrorWidget(
                          favoritesState.message,
                          () => context
                              .read<FavoritesBloc>()
                              .add(FavoritesLoadRequested()),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavigation(initialIndex: 1),
    );
  }
}