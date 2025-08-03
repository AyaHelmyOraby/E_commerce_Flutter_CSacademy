# E-Commerce App with Flutter BLoC, Dio, and FakeStoreAPI

This app is a simple e-commerce application built using **Flutter**, **BLoC (Cubit)** for state management, and **Dio** for API interaction. The app uses the public [FakeStoreAPI](https://fakestoreapi.com/) to simulate login, register, fetch, add, update, delete, and search products.

---

## 📋 Full Functionality Overview

This app offers a complete set of basic e-commerce features using fake APIs and local state management:

### 🔐 **Authentication**

* **Login**: Authenticates user credentials and emits success/failure states.
* **Register**: Sends new user info to register via POST request.

### 🛍️ **Product Management**

* **Fetch All Products**: Retrieves product list using GET.
* **Add Product**: Sends product data to create a new item.
* **Update Product**: Updates a product locally and on the API.
* **Delete Product**: Removes a product by ID.

### 🔍 **Search**

* Dynamic, case-insensitive search through product titles.
* Clears search and resets view to full product list.

### ❤️ **Favorites**

* Toggle favorite status locally (no API interaction).

### 🛒 **Add to Cart**

* Toggle 'add to cart' flag locally in the product model.

### ⚙️ **Optimistic UI Updates**

* Product updates and deletes happen visually first.
* API errors automatically revert to the previous state.

---

## 📚 Concepts Covered:

1. **BLoC (Cubit) Architecture**
2. **Dio for HTTP Requests**
3. **State Management for Login, Register, and Products**
4. **Optimistic UI Updates**
5. **Search, Favorites, and Add-to-Cart Local States**

---

## 🔧 Cubit Implementation Summary

### ProductCubit

* Handles loading, success, failure, and UI interactions for products.
* Uses `_allProducts` to store the original list and apply filters.

### LoginCubit

* Handles login API request.
* Emits loading, success, or failure states.

### RegisterCubit

* Handles register API call.
* Emits loading, success, or failure states.

---

## 🧪 Testing Your Cubits

* Use fake credentials to login: `"mor_2314" / "83r5^_"`
* Register with any email/username.
* Check console for product logs after adding/deleting.

---

## ✅ Summary

This app simulates a **mini online store** with full-stack behavior using only frontend code and a public API. It’s ideal for learning:

* Clean architecture using BLoC
* API handling with Dio
* Realtime UI updates with search, cart, and favorites

---

