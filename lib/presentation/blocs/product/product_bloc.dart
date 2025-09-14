import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/search_products_usecase.dart';
import '../../../data/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  List<ProductModel> allProducts = [];

  ProductBloc({
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
  }) : super(ProductInitial()) {
    on<ProductRequested>((event, emit) async {
      emit(ProductLoadInProgress());
      try {
        allProducts = await getProductsUseCase() as List<ProductModel>;
        emit(ProductLoadSuccess(allProducts));
      } catch (_) {
        emit(ProductLoadFailure());
      }
    });

    on<ProductSearchRequested>((event, emit) async {
      emit(ProductLoadInProgress());
      try {
        final results = await searchProductsUseCase(event.query) as List<ProductModel>;
        emit(ProductLoadSuccess(results));
      } catch (_) {
        emit(ProductLoadFailure());
      }
    });
  }
}