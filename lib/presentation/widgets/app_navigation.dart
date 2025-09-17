import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../pages/home_page.dart';
import '../pages/cart_page.dart';
import '../pages/favorites_page.dart';
import '../pages/profile_page.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    HomePage(),
    FavoritesPage(),
    CartPage(),
    ProfilePage(),
  ];
  
  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => _pages[index],
          transitionDuration: Duration.zero,
        ),
      );
    }
  }
  
  @override
  void initState() {
    super.initState();
    _setCurrentIndex();
  }
  
  void _setCurrentIndex() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final currentWidget = context.widget;
    
    if (currentWidget.runtimeType.toString().contains('HomePage') ||
        currentRoute == '/home') {
      _currentIndex = 0;
    } else if (currentWidget.runtimeType.toString().contains('FavoritesPage') ||
               currentRoute == '/favorites') {
      _currentIndex = 1;
    } else if (currentWidget.runtimeType.toString().contains('CartPage') ||
               currentRoute == '/cart') {
      _currentIndex = 2;
    } else if (currentWidget.runtimeType.toString().contains('ProfilePage') ||
               currentRoute == '/profile') {
      _currentIndex = 3;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.itemCount;
              }
              
              return Stack(
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  if (itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          itemCount > 99 ? '99+' : itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          activeIcon: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.itemCount;
              }
              
              return Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          itemCount > 99 ? '99+' : itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          label: 'Cart',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}