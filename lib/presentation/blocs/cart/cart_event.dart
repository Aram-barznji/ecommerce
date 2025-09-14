part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartRequested extends CartEvent {}

class CartAddRequested extends CartEvent {
  final int productId;
  final String name;
  final double price;

  CartAddRequested(this.productId, this.name, this.price);

  @override
  List<Object?> get props => [productId, name, price];
}

class CartRemoveRequested extends CartEvent {
  final int productId;

  CartRemoveRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}