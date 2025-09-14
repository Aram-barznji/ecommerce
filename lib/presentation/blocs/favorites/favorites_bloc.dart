import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/toggle_favorite_usecase.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import '../../../domain/entities/product.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;

  FavoritesBloc({
    required this.toggleFavoriteUseCase,
    required this.getFavoritesUseCase,
  }) : super(FavoritesInitial()) {
    on<FavoritesRequested>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final favorites = await getFavoritesUseCase();
        emit(FavoritesLoaded(favorites));
      } catch (_) {
        emit(FavoritesFailure());
      }
    });

    on<FavoritesToggleRequested>((event, emit) async {
      await toggleFavoriteUseCase(event.productId, event.isFavorite);
      add(FavoritesRequested()); // Refresh list
    });
  }
}