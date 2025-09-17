import 'package:equatable/equatable.dart';

class Favorites extends Equatable {
  final List<String> favoriteProductIds;
  
  const Favorites({
    required this.favoriteProductIds,
  });
  
  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }
  
  @override
  List<Object?> get props => [favoriteProductIds];
}