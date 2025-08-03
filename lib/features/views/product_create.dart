import 'package:e_commerce/features/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';

class ProductCreate extends StatefulWidget {
  const ProductCreate({super.key});

  @override
  _ProductCreateState createState() => _ProductCreateState();
}

class _ProductCreateState extends State {
  final _formkey = GlobalKey<FormState>();

  final titlecontroller = TextEditingController();
  final imageontroller = TextEditingController();

  final pricecontroller = TextEditingController();

  final descriptionontroller = TextEditingController();

  void submit() {
    if (_formkey.currentState!.validate()) {
      final product = ProductModel(
          id: 0,
          title: titlecontroller.text,
          image:
              "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp",
          price: double.parse(pricecontroller.text),
          description: descriptionontroller.text);

      BlocProvider.of<ProductCubit>(context).addProduct(product);
      Navigator.pop(context, true); // Go back to list screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formkey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: titlecontroller,
                    decoration: InputDecoration(labelText: "Product Title"),
                  ),
                  TextFormField(
                      controller: imageontroller,
                      decoration: InputDecoration(labelText: "Image URL")),
                  TextFormField(
                    controller: pricecontroller,
                    decoration: InputDecoration(labelText: "Price"),
                  ),
                  TextFormField(
                    controller: descriptionontroller,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: submit, child: Text("Submit")),
                ],
              ))),
    );
  }
}
