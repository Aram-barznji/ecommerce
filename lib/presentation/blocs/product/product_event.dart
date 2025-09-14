part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductRequested extends ProductEvent {}

class ProductSearchRequested extends ProductEvent {
  final String query;

  ProductSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}