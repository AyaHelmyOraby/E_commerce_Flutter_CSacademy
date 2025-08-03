import 'package:e_commerce/features/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/features/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isHovered = false;
  bool _isLoaded = false;
  bool _isButtonHovered = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation after build
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() => _isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF375596),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 500),
          padding: EdgeInsets.only(top: _isLoaded ? 0 : 30),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: _isLoaded ? 1 : 0,
            child: Column(
              children: [
                const SizedBox(height: 70),
                Center(
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: _isHovered ? 1.2 : 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      builder: (context, scale, child) => Transform.scale(
                        scale: scale,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: _isHovered
                                ? [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 80,
                                      offset: Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 40,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 40,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              widget.product.image,
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      child: const SizedBox(),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color(0xFF375596),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Divider(height: 30, thickness: 1.5),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 40),
                      MouseRegion(
                        onEnter: (_) => setState(() => _isButtonHovered = true),
                        onExit: (_) => setState(() => _isButtonHovered = false),
                        child: AnimatedScale(
                          scale: _isButtonHovered ? 1.07 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _isButtonHovered
                                  ? const Color(0xFF2E4A87)
                                  : const Color(0xFF375596),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _isButtonHovered
                                  ? [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 18,
                                        offset: Offset(0, 8),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<ProductCubit>()
                                      .toggleAddToCard(widget.product.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Added to card successfully"),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                splashColor: Colors.white24,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight
                                            .bold, // Makes it stronger
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
