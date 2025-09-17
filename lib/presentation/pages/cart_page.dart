import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/cart/cart_event.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/app_navigation.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(CartLoadRequested());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return AppUtils.buildLoadingWidget();
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, 
                         size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart is empty',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        cartItem: state.items[index],
                        onRemove: (productId) {
                          context.read<CartBloc>().add(CartItemRemoved(productId));
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total (${state.itemCount} items):',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            AppUtils.formatPrice(state.totalPrice),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            AppUtils.showSnackBar(
                              context,
                              'Checkout feature coming soon!',
                            );
                          },
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return AppUtils.buildErrorWidget(
              state.message,
              () => context.read<CartBloc>().add(CartLoadRequested()),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: AppNavigation(),
    );
  }
}