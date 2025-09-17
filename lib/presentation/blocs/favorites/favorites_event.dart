import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  
  @override
  List<Object?> get props => [];
}

class FavoritesLoadRequested extends FavoritesEvent {}

class FavoriteToggled extends FavoritesEvent {
  final Product product;
  
  const FavoriteToggled(this.product);
  
  @override
  List<Object?> get props => [product];
}