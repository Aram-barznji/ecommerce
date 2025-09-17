import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  
  @override
  List<Object?> get props => [];
}

class CartLoadRequested extends CartEvent {}

class CartItemAdded extends CartEvent {
  final Product product;
  final int quantity;
  
  const CartItemAdded(this.product, this.quantity);
  
  @override
  List<Object?> get props => [product, quantity];
}

class CartItemRemoved extends CartEvent {
  final String productId;
  
  const CartItemRemoved(this.productId);
  
  @override
  List<Object?> get props => [productId];
}