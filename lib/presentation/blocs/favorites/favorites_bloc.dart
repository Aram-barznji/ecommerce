import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  
  FavoritesBloc({
    required this.toggleFavoriteUseCase,
    required this.getFavoritesUseCase,
  }) : super(FavoritesInitial()) {
    on<FavoritesLoadRequested>(_onLoadRequested);
    on<FavoriteToggled>(_onFavoriteToggled);
  }
  
  Future<void> _onLoadRequested(
    FavoritesLoadRequested event,
    Emitter<FavoritesState> emitter,
  ) async {
    emitter(FavoritesLoading());
    try {
      final favorites = await getFavoritesUseCase();
      emitter(FavoritesLoaded(favorites));
    } catch (e) {
      emitter(FavoritesError(e.toString()));
    }
  }
  
  Future<void> _onFavoriteToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emitter,
  ) async {
    try {
      await toggleFavoriteUseCase(event.product);
      add(FavoritesLoadRequested());
    } catch (e) {
      emitter(FavoritesError(e.toString()));
    }
  }
}