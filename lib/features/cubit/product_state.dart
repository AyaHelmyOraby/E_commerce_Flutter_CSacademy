import 'package:e_commerce/features/models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class _CreateProductState  extends ProductState{
  

}

class ProductSuccess extends ProductState {
  final List<ProductModel> products;
  ProductSuccess(this.products);
}

class ProductFail extends ProductState {
  final String Msg;

  ProductFail(this.Msg);
}
