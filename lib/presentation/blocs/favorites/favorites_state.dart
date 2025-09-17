import 'package:equatable/equatable.dart';
import '../../../domain/entities/favorites.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final Favorites favorites;
  
  const FavoritesLoaded(this.favorites);
  
  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;
  
  const FavoritesError(this.message);
  
  @override
  List<Object?> get props => [message];
}