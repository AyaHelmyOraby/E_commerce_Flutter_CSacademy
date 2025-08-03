import 'package:e_commerce/features/cubit/product_cubit.dart';
import 'package:e_commerce/features/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductEdit extends StatefulWidget {
  final ProductModel product;

  const ProductEdit({super.key, required this.product});

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController imageController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    priceController = TextEditingController(text: widget.product.price.toString());
    imageController = TextEditingController(text: widget.product.image);
    descriptionController = TextEditingController(text: widget.product.description);
  }

  void submitUpdate() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedProduct = ProductModel(
          id: widget.product.id,
          title: titleController.text,
          price: double.parse(priceController.text),
          image: imageController.text,
          description: descriptionController.text,
          isFavourite :false
        );

        await BlocProvider.of<ProductCubit>(context).updateProduct(updatedProduct);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Product updated successfully")),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Update failed: ${e.toString()}")),
          );
        }
      }
    }
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? "Required field" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 55, 59, 134),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                buildTextField(titleController, "Title", Icons.title),
                const SizedBox(height: 16),
                buildTextField(imageController, "Image URL", Icons.image),
                const SizedBox(height: 16),
                buildTextField(priceController, "Price", Icons.attach_money, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                buildTextField(descriptionController, "Description", Icons.description),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: submitUpdate,
                    icon: const Icon(Icons.save),
                    label: const Text("Update", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 78, 93, 158),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
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
