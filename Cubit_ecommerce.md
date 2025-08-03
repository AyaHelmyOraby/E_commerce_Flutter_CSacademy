# E-Commerce App with Flutter BLoC, Dio, and FakeStoreAPI

This app is a simple e-commerce application built using **Flutter**, **BLoC (Cubit)** for state management, and **Dio** for API interaction. The app uses the public [FakeStoreAPI](https://fakestoreapi.com/) to simulate login, register, fetch, add, update, delete, and search products.

---

## 📚 Concepts Covered:

1. **BLoC (Cubit) Architecture**
2. **Dio for HTTP Requests**
3. **State Management for Login, Register, and Products**
4. **Optimistic UI Updates**
5. **Search, Favorites, and Add-to-Cart Local States**

---

## 1. ProductCubit (State Management for Products)

```dart
class ProductCubit extends Cubit<ProductState> {
  final Dio dio;
  ProductCubit(this.dio) : super(ProductInitial());
```

* `ProductCubit` extends `Cubit<ProductState>` to manage product-related states.
* Takes `Dio` instance to perform HTTP requests.
* Starts with `ProductInitial()` state.

### 🔄 Fetch Products

```dart
Future<void> fetchProducts() async {
  emit(ProductLoading());
```

* Triggers a loading state before the fetch.

```dart
final response = await dio.get('https://fakestoreapi.com/products');
```

* Performs a GET request to fetch all products.

```dart
final data = response.data as List;
_allProducts = data.map((e) => ProductModel.fromJson(e)).toList();
```

* Parses JSON response to `ProductModel` list.

```dart
emit(ProductSuccess(_allProducts));
```

* Emits the successful product list to UI.

### ➕ Add Product

```dart
Future<void> addProduct(ProductModel product) async {
  emit(ProductLoading());
```

* Shows loading while sending product data.

```dart
final response = await dio.post('https://fakestoreapi.com/products', data: product.toJson());
final newProduct = ProductModel.fromJson(response.data);
```

* Sends POST request and parses the response.

```dart
if (state is ProductSuccess) {
  final oldProducts = (state as ProductSuccess).products;
  emit(ProductSuccess([...oldProducts, newProduct]));
}
```

* Appends new product to the current list and emits success.

### 🔄 Update Product (Optimistic)

```dart
final index = products.indexWhere((p) => p.id == product.id);
products[index] = product;
emit(ProductSuccess(products));
```

* Updates UI immediately before API call (optimistic update).

```dart
await dio.put('https://fakestoreapi.com/products/${product.id}', data: product.toJson());
```

* PUT request to update product on server.

```dart
// If error: revert UI to old state
emit(ProductSuccess(currentState.products));
```

* Rollback on failure.

### 🗑️ Delete Product

```dart
final products = List<ProductModel>.from(currentState.products)
  ..removeWhere((p) => p.id == productId);
```

* Removes product locally and updates UI.

```dart
await dio.delete("https://fakestoreapi.com/products/$productId");
```

* Sends DELETE request to server.

### 🔍 Search & Filter

```dart
void updateSearchQuery(String query) {
  searchQuery = query;
  final filtered = _allProducts.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();
  emit(ProductSuccess(filtered));
}
```

* Filters products locally based on user query.

### ❤️ Toggle Favourite

```dart
current[index].isFavourite = !current[index].isFavourite;
```

* Inverts favorite flag.

### 🛒 Toggle Add to Cart

```dart
current[index].addToCard = !current[index].addToCard;
```

* Inverts add-to-cart flag.

---

## 2. LoginCubit (State Management for Authentication)

```dart
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(Dio dio) : super(InitialState());
  final Dio dio = Dio();
```

* Starts in `InitialState`, uses Dio for HTTP.

```dart
emit(LoginLoadingState());
```

* Emit loading before request.

```dart
final res = await dio.post('https://fakestoreapi.com/auth/login', data: {"username": username, "password": password});
```

* Sends login data.

```dart
if (res.statusCode == 200) emit(LoginSuccessState());
```

* Emits success or failure based on response.

---

## 3. RegisterCubit (State Management for Registration)

```dart
class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitial());
```

* Starts with empty state, creates Dio instance.

```dart
emit(RegisterLoading());
```

* Show loading state.

```dart
final res = await dio.post('https://fakestoreapi.com/users', data: {"username": username, "password": password, "email": email});
```

* Sends user data for registration.

```dart
if (res.statusCode == 200 || res.statusCode == 201) emit(RegisterSuccess());
```

* Emits success/failure based on status code.

---

## 📦 Models (Example)

Assuming `ProductModel.fromJson()` is defined like:

```dart
factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'],
    title: json['title'],
    price: json['price'],
    description: json['description'],
    image: json['image'],
    isFavourite: false,
    addToCard: false,
  );
}
```

* Parses product data from JSON.

---

## 🧪 Testing Your Cubits

* Use fake credentials to login: `"mor_2314" / "83r5^_"`
* Register with any email/username.
* Check console for product logs after adding/deleting.

---

