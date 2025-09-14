part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesRequested extends FavoritesEvent {}

class FavoritesToggleRequested extends FavoritesEvent {
  final int productId;
  final bool isFavorite;

  FavoritesToggleRequested(this.productId, this.isFavorite);

  @override
  List<Object?> get props => [productId, isFavorite];
}