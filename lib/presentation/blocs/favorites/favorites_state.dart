part of 'favorites_bloc.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Product> favorites;

  FavoritesLoaded(this.favorites);
}

class FavoritesFailure extends FavoritesState {}