import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_to_cart_usecase.dart';
import '../../../domain/usecases/remove_from_cart_usecase.dart';
import '../../../domain/usecases/get_cart_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final GetCartUseCase getCartUseCase;
  
  CartBloc({
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.getCartUseCase,
  }) : super(CartInitial()) {
    on<CartLoadRequested>(_onLoadRequested);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
  }
  
  Future<void> _onLoadRequested(
    CartLoadRequested event,
    Emitter<CartState> emitter,
  ) async {
    emitter(CartLoading());
    try {
      final items = await getCartUseCase();
      emitter(CartLoaded(items));
    } catch (e) {
      emitter(CartError(e.toString()));
    }
  }
  
  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emitter,
  ) async {
    try {
      await addToCartUseCase(event.product, event.quantity);
      add(CartLoadRequested());
    } catch (e) {
      emitter(CartError(e.toString()));
    }
  }
  
  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emitter,
  ) async {
    try {
      await removeFromCartUseCase(event.productId);
      add(CartLoadRequested());
    } catch (e) {
      emitter(CartError(e.toString()));
    }
  }
}