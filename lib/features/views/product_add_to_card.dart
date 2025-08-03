import 'package:e_commerce/features/cubit/product_cubit.dart';
import 'package:e_commerce/features/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cardscreen extends StatelessWidget {
  const Cardscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Card")),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductSuccess) {
            final cardProducts =
                state.products.where((p) => p.addToCard).toList();

            if (cardProducts.isEmpty) {
              return const Center(child: Text("No In Card yet."));
            }

            return ListView.builder(
              itemCount: cardProducts.length,
              itemBuilder: (context, index) {
                final product = cardProducts[index];
                return ListTile(
                  leading: Image.network(product.image ?? "", width: 50),
                  title: Text(product.title ?? ''),
                  subtitle: Text("${product.price?.toStringAsFixed(2)} \$"),
                  trailing: IconButton(
                    icon: Icon(Icons.shopping_cart,
                        color: Color.fromARGB(255, 28, 126, 41)),
                    onPressed: () {
                      context.read<ProductCubit>().toggleAddToCard(product.id!);
                       ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Removed from card successfully"),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Color.fromARGB(255, 245, 12, 4),
                                    ),
                                  );
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
