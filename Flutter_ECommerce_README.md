
# 🛠️ Problem-Solution Log for E-Commerce Flutter App

This document captures key issues encountered during development of the Flutter E-Commerce app (Cubit + REST API) and how they were solved.

---

## 📌 1. **Add Product - Form Submitted but Nothing Happened**

### 🔍 Problem:
When clicking the **Submit** button in `ProductCreate` screen, nothing changed in the product list UI.

### ✅ Solution:
The issue was that the form only called `Navigator.pop(context);` without passing a result. The main product list page didn’t know that a new product was added.

### ✅ Fix:
1. **Return a value from `ProductCreate`:**

```dart
Navigator.pop(context, true); // signal success
```

2. **In main product list page**, use `await` and reload data:

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const ProductCreate()),
);

if (result == true) {
  context.read<ProductCubit>().fetchProducts(); // reload
}
```

---

## 📌 2. **UI Doesn’t Update After Adding Product**

### 🔍 Problem:
The product gets added via API, but it doesn't appear in the product list on returning back.

### ✅ Solution:
- Ensure the product list Cubit state updates properly by refetching products or adding the product locally to the state.
- Use result passed via `Navigator.pop` as a signal to refresh.

---

## 📌 3. **products is not defined on ProductState**

### 🔍 Problem:
```plaintext
The getter 'products' isn't defined for the type 'ProductState'.
```

### ✅ Solution:
Only `ProductSuccess` holds a `products` list. So when accessing it from `state`, use pattern matching or check for type:

```dart
if (state is ProductSuccess) {
  final products = state.products;
  ...
}
```

Or with `BlocBuilder`:

```dart
BlocBuilder<ProductCubit, ProductState>(
  builder: (context, state) {
    if (state is ProductSuccess) {
      final products = state.products;
      return ListView.builder(...);
    } else if (state is ProductLoading) {
      return CircularProgressIndicator();
    } else {
      return Text("Failed to load");
    }
  },
)
```

---

## 📌 4. **TypeError: Null is not a subtype of type 'String'**

### 🔍 Problem:
```
TypeError: null: type 'Null' is not a subtype of type 'String'
```

### ✅ Solution:
- The error was due to wrong field mapping from API response or sending null values.
- Fix by adding null checks or defaults in model constructor, or form validation.

---

## 📌 5. **Returned API Format Doesn’t Match Model**

### 🔍 Problem:
DummyJSON returns a list like:

```json
{
  "products": [ ... ]
}
```

### ✅ Solution:
When parsing response, extract the `products` key:

```dart
final productsJson = response.data['products'];
final products = productsJson.map<ProductModel>((e) => ProductModel.fromJson(e)).toList();
```

---

## 📌 6. **Routing Between Pages**

### 🔍 Problem:
Navigating between pages using long `MaterialPageRoute` calls.

### ✅ Solution:
Created `app_route.dart` inside `core/routing/`:

```dart
// core/routing/app_route.dart
class AppRoutes {
  static const String productList = '/';
  static const String productCreate = '/create';
}

final routes = {
  AppRoutes.productList: (context) => const ProductListScreen(),
  AppRoutes.productCreate: (context) => const ProductCreate(),
};
```

Then in `MaterialApp`:

```dart
MaterialApp(
  routes: routes,
  initialRoute: AppRoutes.productList,
)
```

---

## 📌 7. **Cubit AddProduct Not Emitting Success State**

### 🔍 Problem:
After posting the product, state doesn't update to success.

### ✅ Solution:
Ensure `AddProduct` emits a success state or refetches products after adding:

```dart
await dio.post(...);
fetchProducts(); // reload after adding
```

---

## ✅ Tips

- Use `TextFormField` with `.validator` to prevent null errors.
- Use `context.read<T>()` instead of `BlocProvider.of<T>(context)` if you have access to `BuildContext`.
- Always handle all possible `Cubit` states: Loading, Success, and Failure.

---
