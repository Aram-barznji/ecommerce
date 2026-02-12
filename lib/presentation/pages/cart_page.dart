import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../core/notification_service.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/cart/cart_event.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/app_navigation.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
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
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return AppUtils.buildLoadingWidget();
            } else if (state is CartLoaded) {
              if (state.items.isEmpty) {
                return Column(
                  children: [
                    _buildHeader(0),
                    Expanded(
                      child: AppUtils.buildEmptyState(
                        icon: Icons.shopping_cart_outlined,
                        title: 'Your cart is empty',
                        subtitle: 'Add some items to get started!',
                      ),
                    ),
                  ],
                );
              }

              final subtotal = state.totalPrice;
              final shipping = subtotal > 100 ? 0.0 : 9.99;
              final total = subtotal + shipping;

              return Column(
                children: [
                  _buildHeader(state.itemCount),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  // ─── Order Summary ───
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _summaryRow('Subtotal', AppUtils.formatPrice(subtotal)),
                          const SizedBox(height: 8),
                          _summaryRow(
                            'Shipping',
                            shipping == 0
                                ? 'FREE'
                                : AppUtils.formatPrice(shipping),
                            valueColor: shipping == 0
                                ? AppTheme.successColor
                                : null,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1),
                          ),
                          _summaryRow(
                            'Total',
                            AppUtils.formatPrice(total),
                            isBold: true,
                            valueColor: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                AppUtils.showSnackBar(
                                  context,
                                  'Order placed successfully! 🎉',
                                );
                                NotificationService.instance.showNotification(
                                  id: 999,
                                  title: 'Order Confirmed ✅',
                                  body:
                                      'Your order of ${AppUtils.formatPrice(total)} has been placed!',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('Place Order'),
                            ),
                          ),
                        ],
                      ),
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
      ),
      bottomNavigationBar: const AppNavigation(initialIndex: 2),
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Text(
            'My Cart',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 8),
          if (count > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}