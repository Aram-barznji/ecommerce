import 'package:bloc/bloc.dart';
import 'package:e_commerce/core/notification_service.dart';
import 'package:e_commerce/domain/entities/cart_item.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/add_to_cart_usecase.dart';
import '../../../domain/usecases/remove_from_cart_usecase.dart';
import '../../../domain/usecases/get_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final GetCartUseCase getCartUseCase;

  CartBloc({
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.getCartUseCase,
  }) : super(CartInitial()) {
    on<CartRequested>((event, emit) async {
      final cart = await getCartUseCase.cart;
      emit(CartLoaded(cart));
    });

    on<CartAddRequested>((event, emit) async {
      addToCartUseCase.call(event.productId, event.name, event.price);
      final cart = await getCartUseCase.cart;
      emit(CartLoaded(cart));
    });

    on<CartRemoveRequested>((event, emit) async {
      removeFromCartUseCase.call(getCartUseCase.cart, event.productId);
      final cart = await getCartUseCase.cart;
      emit(CartLoaded(cart));
      // Add notification
      NotificationService().showNotification(
        id: 1,
        title: 'Item Removed',
        body: 'Item removed from cart.',
      );
    });
  }
}