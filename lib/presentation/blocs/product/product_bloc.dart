import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/search_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  
  ProductBloc({
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
  }) : super(ProductInitial()) {
    on<ProductLoadRequested>(_onLoadRequested);
    on<ProductSearchRequested>(_onSearchRequested);
    on<ProductSearchCleared>(_onSearchCleared);
  }
  
  Future<void> _onLoadRequested(
    ProductLoadRequested event,
    Emitter<ProductState> emitter,
  ) async {
    emitter(ProductLoading());
    try {
      final products = await getProductsUseCase();
      emitter(ProductLoaded(products));
    } catch (e) {
      emitter(ProductError(e.toString()));
    }
  }
  
  Future<void> _onSearchRequested(
    ProductSearchRequested event,
    Emitter<ProductState> emitter,
  ) async {
    emitter(ProductLoading());
    try {
      final products = await searchProductsUseCase(event.query);
      emitter(ProductSearchLoaded(products, event.query));
    } catch (e) {
      emitter(ProductError(e.toString()));
    }
  }
  
  Future<void> _onSearchCleared(
    ProductSearchCleared event,
    Emitter<ProductState> emitter,
  ) async {
    add(ProductLoadRequested());
  }
}