import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/notification_service.dart';
import 'data/data_sources/local_db.dart';
import 'data/data_sources/local_preferences.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/favorites_repository.dart';

import 'domain/usecases/login_usecase.dart' as login_uc;
import 'domain/usecases/get_products_usecase.dart' as product_uc;
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
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/cart_page.dart';
import 'presentation/pages/favorites_page.dart';
import 'presentation/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.init();

  final localDB = LocalDB();
  final prefs = await LocalPreferences.init();

  final authRepository = AuthRepositoryImpl(localDB);
  final productRepository = ProductRepositoryImpl(localDB);
  final favoritesRepository = FavoritesRepositoryImpl(prefs);

  final loginUseCase = login_uc.LoginUseCase(authRepository);
  final getProductsUseCase = product_uc.GetProductsUseCase(productRepository);
  final searchProductsUseCase = SearchProductsUseCase(productRepository);
  final addToCartUseCase = AddToCartUseCase();
  final removeFromCartUseCase = RemoveFromCartUseCase();
  final getCartUseCase = GetCartUseCase();
  final toggleFavoriteUseCase = ToggleFavoriteUseCase(favoritesRepository);
  final getFavoritesUseCase = GetFavoritesUseCase(favoritesRepository, productRepository);

  runApp(MyApp(
    authBloc: AuthBloc(loginUseCase: loginUseCase, authRepository: authRepository),
    productBloc: ProductBloc(
      getProductsUseCase: getProductsUseCase,
      searchProductsUseCase: searchProductsUseCase,
    ),
    cartBloc: CartBloc(
      addToCartUseCase: addToCartUseCase,
      removeFromCartUseCase: removeFromCartUseCase,
      getCartUseCase: getCartUseCase,
    ),
    favoritesBloc: FavoritesBloc(
      toggleFavoriteUseCase: toggleFavoriteUseCase,
      getFavoritesUseCase: getFavoritesUseCase,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final ProductBloc productBloc;
  final CartBloc cartBloc;
  final FavoritesBloc favoritesBloc;

  const MyApp({
    super.key,
    required this.authBloc,
    required this.productBloc,
    required this.cartBloc,
    required this.favoritesBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authBloc),
        BlocProvider(create: (_) => productBloc),
        BlocProvider(create: (_) => cartBloc),
        BlocProvider(create: (_) => favoritesBloc),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/cart': (context) => const CartPage(),
          '/favorites': (context) => const FavoritesPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}