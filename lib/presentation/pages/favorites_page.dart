import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../widgets/product_item.dart';
import '../widgets/app_navigation.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FavoritesBloc>().add(FavoritesRequested());

    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ProductItem(product: favorites[index]);
              },
            );
          } else {
            return const Center(child: Text('No favorites'));
          }
        },
      ),
      bottomNavigationBar: const AppNavigation(currentIndex: 2),
    );
  }
}