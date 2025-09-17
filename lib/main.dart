import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants.dart';
import 'core/notification_service.dart';
import 'data/data_sources/local_db.dart';
import 'data/data_sources/local_preferences.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/favorites_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/search_products_usecase.dart';
import 'domain/usecases/add_to_cart_usecase.dart';
import 'domain/usecases/remove_from_cart_usecase.dart';
import 'domain/usecases/get_cart_usecase.dart';
import 'domain/usecases/toggle_favorite_usecase.dart';
import 'domain/usecases/get_favorites_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/product/product_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/favorites/favorites_bloc.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await LocalDatabase.instance.database;
  await LocalPreferences.instance.init();
  await NotificationService.instance.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepositoryImpl()),
        RepositoryProvider(create: (_) => ProductRepositoryImpl()),
        RepositoryProvider(create: (_) => FavoritesRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              loginUseCase: LoginUseCase(
                context.read<AuthRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              getProductsUseCase: GetProductsUseCase(
                context.read<ProductRepositoryImpl>(),
              ),
              searchProductsUseCase: SearchProductsUseCase(
                context.read<ProductRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => CartBloc(
              addToCartUseCase: AddToCartUseCase(
                context.read<ProductRepositoryImpl>(),
              ),
              removeFromCartUseCase: RemoveFromCartUseCase(
                context.read<ProductRepositoryImpl>(),
              ),
              getCartUseCase: GetCartUseCase(
                context.read<ProductRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(
              toggleFavoriteUseCase: ToggleFavoriteUseCase(
                context.read<FavoritesRepositoryImpl>(),
              ),
              getFavoritesUseCase: GetFavoritesUseCase(
                context.read<FavoritesRepositoryImpl>(),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'E-Commerce App',
          theme: AppTheme.lightTheme,
          home: SplashPage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}