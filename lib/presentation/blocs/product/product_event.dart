import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  
  @override
  List<Object?> get props => [];
}

class ProductLoadRequested extends ProductEvent {}

class ProductSearchRequested extends ProductEvent {
  final String query;
  
  const ProductSearchRequested(this.query);
  
  @override
  List<Object?> get props => [query];
}

class ProductSearchCleared extends ProductEvent {}