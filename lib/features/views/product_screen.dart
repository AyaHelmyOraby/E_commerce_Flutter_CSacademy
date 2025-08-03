import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/features/cubit/product_cubit.dart';
import 'package:e_commerce/features/cubit/product_state.dart';
import 'package:e_commerce/features/views/product_add_to_card.dart';
import 'package:e_commerce/features/views/product_create.dart';
import 'package:e_commerce/features/views/product_favorite.dart';
import 'package:e_commerce/features/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ProductCubit>().clearSearch();
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homeScreen,
              (route) => false,
            );
          },
        ),
        title: InkWell(
          onTap: () {
            context.read<ProductCubit>().clearSearch();
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homeScreen,
              (route) => false,
            );
          },
          child: const Text(
            "🛍️ Shop Now",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              context.read<ProductCubit>().clearSearch();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
            tooltip: 'Favorites',
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.read<ProductCubit>().clearSearch();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Cardscreen()),
              );
            },
            tooltip: 'Add To Card',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<ProductCubit>().clearSearch();
              Navigator.pushReplacementNamed(context, Routes.loginscreen);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out successfully")),
              );
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context.read<ProductCubit>().clearSearch();
                        },
                      ),
                    ),
                    onChanged: (value) {
                      context.read<ProductCubit>().updateSearchQuery(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search Products',
                  onPressed: () {
                    final query = searchController.text;
                    context.read<ProductCubit>().updateSearchQuery(query);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductSuccess) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 50),
                          const SizedBox(height: 16),
                          const Text(
                            "No products found",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextButton(
                            onPressed: () {
                              searchController.clear();
                              context.read<ProductCubit>().clearSearch();
                            },
                            child: const Text("Clear search"),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    itemCount: state.products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: ProductItem(
                          key: ValueKey(product.id),
                          product: product,
                        ),
                      );
                    },
                  );
                } else if (state is ProductFail) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.Msg,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<ProductCubit>().fetchProducts(),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text("No products available"));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const ProductCreate(),
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(opacity: anim, child: child);
              },
            ),
          );
          if (result == true) {
            context.read<ProductCubit>().fetchProducts();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
        backgroundColor: const Color.fromARGB(255, 52, 79, 83),
        foregroundColor: Colors.white,
        tooltip: "Create New Product",
      ),
    );
  }
}
