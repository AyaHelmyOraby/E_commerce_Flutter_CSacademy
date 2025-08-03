import 'package:e_commerce/features/cubit/product_cubit.dart';
import 'package:e_commerce/features/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(" Favorites")),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductSuccess) {
            final favoriteProducts =
                state.products.where((p) => p.isFavourite).toList();

            if (favoriteProducts.isEmpty) {
              return const Center(child: Text("No favorites yet."));
            }

            return ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ListTile(
                  leading: Image.network(product.image ?? "", width: 50),
                  title: Text(product.title ?? ''),
                  subtitle: Text("${product.price?.toStringAsFixed(2)} \$"),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      context.read<ProductCubit>().toggleFavourite(product.id!);
                    },
                  ),
                );
              },
            );
          } else if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("Failed to load favorites"));
          }
        },
      ),
    );
  }
}
