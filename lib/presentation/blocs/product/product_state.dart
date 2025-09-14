part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoadInProgress extends ProductState {}

class ProductLoadSuccess extends ProductState {
  final List<ProductModel> products;

  ProductLoadSuccess(this.products);
}

class ProductLoadFailure extends ProductState {}