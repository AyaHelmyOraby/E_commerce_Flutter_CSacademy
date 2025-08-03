import 'package:e_commerce/features/cubit/product_state.dart';
import 'package:e_commerce/features/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class ProductCubit extends Cubit<ProductState> {
  final Dio dio;

  ProductCubit(this.dio) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final response = await dio.get('https://fakestoreapi.com/products');
      final data = response.data as List;
      _allProducts = data.map((e) => ProductModel.fromJson(e)).toList();
      emit(ProductSuccess(_allProducts));
    } catch (e) {
      emit(ProductFail("Failed to fetch products: ${e.toString()}"));
    }
  }

  Future<void> addProduct(ProductModel product) async {
    emit(ProductLoading());
    try {
      final response = await dio.post(
        'https://fakestoreapi.com/products',
        data: product.toJson(),
      );
      final newProduct = ProductModel.fromJson(response.data);

      if (state is ProductSuccess) {
        final oldProducts = (state as ProductSuccess).products;
        emit(ProductSuccess([...oldProducts, newProduct]));
      } else {
        emit(ProductSuccess([newProduct]));
      }
    } catch (e) {
      emit(ProductFail("Failed to add product: ${e.toString()}"));
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    final currentState = state;
    if (currentState is! ProductSuccess) return;

    // Optimistic update
    final products = List<ProductModel>.from(currentState.products);
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
      emit(ProductSuccess(products));
    }

    try {
      await dio.put(
        'https://fakestoreapi.com/products/${product.id}',
        data: product.toJson(),
      );
    } catch (e) {
      // Revert if API call fails
      emit(ProductSuccess(currentState.products));
      emit(ProductFail("Error updating product: ${e.toString()}"));
    }
  }

  Future<void> deleteProduct(int productId) async {
    final currentState = state;
    if (currentState is! ProductSuccess) return;

    // Optimistic update - remove immediately
    final products = List<ProductModel>.from(currentState.products)
      ..removeWhere((p) => p.id == productId);
    emit(ProductSuccess(products));

    try {
      await dio.delete("https://fakestoreapi.com/products/$productId");
    } catch (e) {
      // Revert if API call fails
      emit(ProductSuccess(currentState.products));
      emit(ProductFail("Error deleting product: ${e.toString()}"));
    }
  }

  void toggleFavourite(int productId) {
    if (state is ProductSuccess) {
      final current =
          List<ProductModel>.from((state as ProductSuccess).products);
      final index = current.indexWhere((p) => p.id == productId);
      if (index != -1) {
        current[index].isFavourite = !current[index].isFavourite;
        emit(ProductSuccess(current));
      }
    }
  }

  List<ProductModel> _allProducts = []; // Store original products
  String searchQuery = "";

  // Add this method to clear search
  void clearSearch() {
    searchQuery = "";
    emit(ProductSuccess(_allProducts));
  }

  void updateSearchQuery(String query) {
    searchQuery = query;

    if (query.isEmpty) {
      emit(ProductSuccess(_allProducts));
    } else {
      final filtered = _allProducts
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(ProductSuccess(filtered));
    }
  }

  void toggleAddToCard(int productId) {
    if (state is ProductSuccess) {
      final current =
          List<ProductModel>.from((state as ProductSuccess).products);
      final index = current.indexWhere((p) => p.id == productId);
      if (index != -1) {
        current[index].addToCard = !current[index].addToCard;
        emit(ProductSuccess(current));
      }
    }
  }
}
